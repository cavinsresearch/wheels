#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.requests python3Packages.beautifulsoup4 python3Packages.jinja2 python3Packages.packaging

"""
nix_wheel_generator.py 🐋⚙️

Automatically scrape PEP 503 package indexes (Nautilus Trader or PyPI) and
generate per‐package Nix expressions for specific Python wheel packages.
Focuses on generating Python version-specific derivations.

Usage:
    ./nix_wheel_generator.py [--source SOURCE] [--output-dir DIR] [--verbose] [--packages PACKAGE1,PACKAGE2]

Examples:
    ./nix_wheel_generator.py --source nautilus
    ./nix_wheel_generator.py --source pypi --packages databento-dbn
    ./nix_wheel_generator.py --source pypi --packages databento-dbn,other-package --output-dir nixpkgs/pkgs --verbose
    ./nix_wheel_generator.py --config config.json --source nautech --packages nautilus-trader
"""

import argparse
import logging
import sys
import hashlib
import base64
import os
import re
import subprocess
import json
from urllib.parse import urljoin, urlparse
from collections import defaultdict
from dataclasses import dataclass
from typing import Dict, List, Set, Tuple, Optional, TypedDict, Any

import requests
from bs4 import BeautifulSoup
from packaging.utils import parse_wheel_filename
from jinja2 import Template
from packaging.version import Version

# ─── Configuration ────────────────────────────────────────────────────────────

class PackageSourceDict(TypedDict):
    base_url: str
    default_packages: List[str]
    default_version_limit: int
    use_full_url: bool

# Default/fallback package source configurations
DEFAULT_PACKAGE_SOURCES: Dict[str, PackageSourceDict] = {
    "nautilus": {
        "base_url": "https://packages.nautechsystems.io/simple/",
        "default_packages": ["nautilus-trader"],
        "default_version_limit": 2,
        "use_full_url": False,  # URLs are relative to base_url
    },
    "pypi": {
        "base_url": "https://pypi.org/simple/",
        "default_packages": ["databento-dbn"],
        "default_version_limit": 1,  # Only latest version for PyPI
        "use_full_url": True,  # PyPI URLs are absolute
    }
}

# Global variable for package sources - can be overridden from config
PACKAGE_SOURCES: Dict[str, PackageSourceDict] = DEFAULT_PACKAGE_SOURCES.copy()

NIX_ENTRY_TEMPLATE = Template(
    """
  "{{ pname }}-{{ version_attr }}" = {{ build_function }} rec {
    pname = "{{ pname }}";
    version = "{{ version }}";

    src = fetchurl {
      url = "{{ url }}";
      sha256 = "{{ sha256 }}";
    };

    format = "wheel";
  };
""".strip()
)

# Template for universal wheels (py3-none-any)
UNIVERSAL_ENTRY_TEMPLATE = Template(
    """
          {{ pname }} = python-final.buildPythonPackage rec {
            pname = "{{ pname }}";
            version = "{{ version }}";
            format = "wheel";
            src = python-final.fetchPypi {
              inherit pname version format;
              sha256 = "{{ sha256 }}";
              dist = "py3";
              python = "py3";
            };
          };
""".strip()
)

# ─── Data Models ──────────────────────────────────────────────────────────────

@dataclass
class WheelInfo:
    """Information about a Python wheel"""
    version: Version
    platform: str
    python_version: int
    href: str
    is_universal: bool = False  # True for py3-none-any wheels

@dataclass
class PackageConfig:
    """Configuration for processing a specific package"""
    name: str
    skip_prereleases: bool = True
    version_limit: int = 2

@dataclass
class GeneratedEntry:
    """Information about a generated Nix entry"""
    platform: str
    python_version: str
    package_name: str
    version: str
    sha256: str
    url: str

@dataclass
class SourceConfig:
    """Configuration for a package source"""
    base_url: str
    default_packages: List[str]
    default_version_limit: int
    use_full_url: bool

# ─── Core Functions ───────────────────────────────────────────────────────────

def setup_logging(verbose: bool) -> None:
    """Configure logging with appropriate level"""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)s: %(message)s",
        datefmt="%H:%M:%S"
    )

def get_source_config(source: str) -> SourceConfig:
    """Get configuration for the specified source"""
    if source not in PACKAGE_SOURCES:
        raise ValueError(f"Unknown source '{source}'. Available sources: {list(PACKAGE_SOURCES.keys())}")
    
    config = PACKAGE_SOURCES[source]
    return SourceConfig(
        base_url=config["base_url"],
        default_packages=config["default_packages"],
        default_version_limit=config["default_version_limit"],
        use_full_url=config["use_full_url"]
    )

def platform_id_from_tag(platform_tag: str) -> Optional[str]:
    """Convert wheel platform tag to Nix platform identifier"""
    # Handle platform-independent wheels
    if platform_tag == "any":
        return "any"  # Special marker for universal wheels
        
    if "manylinux" in platform_tag:
        if "x86_64" in platform_tag:
            return "x86_64-linux"
        if "aarch64" in platform_tag:
            return "aarch64-linux"
    if platform_tag.startswith("macosx"):
        if "arm64" in platform_tag or "universal2" in platform_tag:
            return "aarch64-darwin"
        if "x86_64" in platform_tag:
            return "x86_64-darwin"
    return None

def download_and_hash(url: str) -> str:
    """Download wheel and compute SHA256 hash in SRI format"""
    logging.info("⬇️ Downloading %s", url)
    resp = requests.get(url)
    resp.raise_for_status()
    
    digest = hashlib.sha256(resp.content).digest()
    b64_hash = base64.b64encode(digest).decode('ascii')
    sri_hash = f"sha256-{b64_hash}"
    
    logging.debug("  ↳ SHA256 (SRI): %s", sri_hash)
    return sri_hash

def get_available_packages(source_config: SourceConfig) -> List[str]:
    """Fetch available packages from the PEP 503 index"""
    logging.info("🔍 Fetching package list from %s", source_config.base_url)
    resp = requests.get(source_config.base_url)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")
    
    packages = []
    for a in soup.find_all('a'):
        # Use link text as package name (PEP 503 compliant)
        # Fallback to href-based extraction if no text content
        package_name = a.get_text(strip=True)
        if not package_name:
            href = a.get('href', '').strip('/')
            # Handle PyPI's "simple/package-name" format
            if href.startswith('simple/'):
                package_name = href[7:]  # Remove "simple/" prefix
            else:
                package_name = href
        
        if package_name:
            packages.append(package_name)
    
    logging.debug("Found packages: %s", packages)
    return packages

def filter_target_packages(available_packages: List[str], target_packages: List[str], source_config: SourceConfig) -> List[PackageConfig]:
    """Filter and configure target packages for processing"""
    configs = []
    for target in target_packages:
        if target in available_packages:
            configs.append(PackageConfig(
                name=target,
                version_limit=source_config.default_version_limit
            ))
            logging.info("✅ Target package '%s' found", target)
        else:
            logging.warning("⚠️ Target package '%s' not found in available packages", target)
    
    if not configs:
        logging.error("❌ No target packages found. Available: %s", available_packages)
        sys.exit(1)
    
    return configs

def resolve_wheel_url(href: str, package_name: str, source_config: SourceConfig) -> str:
    """Resolve the full URL for a wheel based on the source configuration"""
    if source_config.use_full_url:
        # For PyPI, hrefs are already absolute URLs
        return href.split("#", 1)[0]  # Remove fragment
    else:
        # For Nautilus, hrefs are relative to the package URL
        clean_href = href.split("#", 1)[0]
        return urljoin(source_config.base_url, f"{package_name}/" + clean_href)

def get_wheels_for_package(package_name: str, config: PackageConfig, source_config: SourceConfig) -> List[WheelInfo]:
    """Get all wheel information for a specific package"""
    logging.info("🔍 Processing package: %s", package_name)
    pkg_url = urljoin(source_config.base_url, f"{package_name}/")
    resp = requests.get(pkg_url)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    wheels = []
    for a in soup.find_all("a"):
        href = a.get("href", "")
        if ".whl" not in href:
            continue
            
        # Check if this version is yanked (skip yanked versions)
        if a.get("data-yanked") is not None:
            logging.debug("⚠️ Skipping yanked wheel: %s (reason: %s)", href, a.get("data-yanked", "no reason given"))
            continue
            
        # Extract filename from URL
        if source_config.use_full_url:
            # For PyPI, extract filename from the full URL
            filename = href.split("/")[-1].split("#")[0]
        else:
            # For Nautilus, extract from relative path
            clean_href = href.split("#", 1)[0]
            filename = clean_href.rsplit("/", 1)[-1]
        
        try:
            dist = parse_wheel_filename(filename)
            name, version, build_tag, tag_set = dist

            # Skip pre-releases if configured
            if config.skip_prereleases and version.is_prerelease:
                logging.debug("⚠️ Skipping pre-release wheel %s", filename)
                continue
            
            # Extract platform and python tags
            platform_tags = []
            py_tags = []
            
            for tag in tag_set:
                if hasattr(tag, 'platform') and tag.platform:
                    platform_tags.append(tag.platform)
                if hasattr(tag, 'interpreter') and tag.interpreter:
                    py_tags.append(tag.interpreter)
                    
            if not platform_tags or not py_tags:
                logging.debug("⚠️ Skipping %s: missing platform or python tag", filename)
                continue
            
            # Check if this is a universal wheel (py3-none-any)
            is_universal_wheel = (
                len(platform_tags) == 1 and platform_tags[0] == "any" and
                len(py_tags) == 1 and py_tags[0] == "py3"
            )
            
            if is_universal_wheel:
                # Universal wheel: create single entry
                wheels.append(WheelInfo(
                    version=version,
                    platform="universal",  # Special marker
                    python_version=0,  # Not version-specific
                    href=href,
                    is_universal=True
                ))
                logging.debug("📦 Universal wheel: %s", filename)
            else:
                # Platform/Python specific wheel: process each combination
                for platform_tag in platform_tags:
                    platform_id = platform_id_from_tag(platform_tag)
                    if not platform_id or platform_id == "any":
                        continue  # Skip unsupported or universal platforms here
                        
                    for py_tag in py_tags:
                        # Handle different Python tag formats
                        if py_tag.startswith('cp'):
                            # CPython specific: cp39, cp310, etc.
                            py_ver = int(py_tag.lstrip("cp"))
                        elif py_tag.startswith('py3'):
                            # Handle py38, py39, etc. format  
                            try:
                                py_ver = int(py_tag[2:])  # Extract version from py38, py39, etc.
                            except ValueError:
                                continue  # Skip unrecognized format
                        else:
                            continue  # Skip unrecognized Python tag format
                        
                        wheels.append(WheelInfo(
                            version=version,
                            platform=platform_id,
                            python_version=py_ver,
                            href=href,
                            is_universal=False
                        ))
            
        except Exception as e:
            logging.debug("Skipping unparsable wheel filename '%s': %s", filename, e)
    
    logging.info("📦 Found %d valid wheels for %s", len(wheels), package_name)
    return wheels

def select_latest_wheels(wheels: List[WheelInfo], version_limit: int) -> Tuple[Dict[Tuple[str, int], WheelInfo], Dict[str, WheelInfo]]:
    """Select the latest wheels for each platform/python combination
    
    Returns:
        Tuple of (platform_specific_wheels, universal_wheels)
    """
    if not wheels:
        return {}, {}
    
    # Separate universal and platform-specific wheels
    universal_wheels = [w for w in wheels if w.is_universal]
    platform_wheels = [w for w in wheels if not w.is_universal]
    
    # Get latest versions across all wheels
    all_versions = set(wheel.version for wheel in wheels)
    sorted_versions = sorted(all_versions, reverse=True)
    latest_versions = sorted_versions[:version_limit]
    
    logging.info("🔢 Limiting to %d latest versions: %s", 
                version_limit, [str(v) for v in latest_versions])
    
    # Process universal wheels - one per package version
    universal_latest: Dict[str, WheelInfo] = {}
    for wheel in universal_wheels:
        if wheel.version in latest_versions:
            package_key = f"{wheel.version}"
            current = universal_latest.get(package_key)
            if current is None or wheel.version > current.version:
                universal_latest[package_key] = wheel
    
    # Process platform-specific wheels
    platform_filtered = [wheel for wheel in platform_wheels if wheel.version in latest_versions]
    platform_python_latest: Dict[Tuple[str, int], WheelInfo] = {}
    
    for wheel in platform_filtered:
        key = (wheel.platform, wheel.python_version)
        current = platform_python_latest.get(key)
        
        if current is None or wheel.version > current.version:
            platform_python_latest[key] = wheel
    
    return platform_python_latest, universal_latest

def generate_nix_entry(package_name: str, wheel: WheelInfo, source_config: SourceConfig) -> Tuple[str, GeneratedEntry]:
    """Generate a Nix expression for a platform-specific wheel"""
    wheel_url = resolve_wheel_url(wheel.href, package_name, source_config)
    sha256 = download_and_hash(wheel_url)
    
    # Create Python version string and build function
    python_suffix = f"python{wheel.python_version}"
    build_function = f"python{wheel.python_version}Packages.buildPythonPackage"
    
    # Normalize package name for Nix
    normalized_name = package_name.replace("-", "_")
    
    nix_expr = NIX_ENTRY_TEMPLATE.render(
        pname=normalized_name,
        version=str(wheel.version),
        version_attr=python_suffix,
        url=wheel_url,
        sha256=sha256,
        build_function=build_function,
    )
    
    entry_info = GeneratedEntry(
        platform=wheel.platform,
        python_version=f"python3.{str(wheel.python_version)[1:]}",
        package_name=normalized_name,
        version=str(wheel.version),
        sha256=sha256,
        url=wheel_url
    )
    
    logging.info("📦 Generated entry: %s-%s for %s (Python 3.%s)", 
                normalized_name, wheel.version, wheel.platform, str(wheel.python_version)[1:])
    
    return nix_expr, entry_info

def generate_universal_entry(package_name: str, wheel: WheelInfo, source_config: SourceConfig) -> Tuple[str, GeneratedEntry]:
    """Generate a Nix expression for a universal wheel (py3-none-any)"""
    wheel_url = resolve_wheel_url(wheel.href, package_name, source_config)
    sha256 = download_and_hash(wheel_url)
    
    # Normalize package name for Nix
    normalized_name = package_name.replace("-", "_")
    
    nix_expr = UNIVERSAL_ENTRY_TEMPLATE.render(
        pname=normalized_name,
        version=str(wheel.version),
        sha256=sha256,
    )
    
    entry_info = GeneratedEntry(
        platform="universal",
        python_version="all",
        package_name=normalized_name,
        version=str(wheel.version),
        sha256=sha256,
        url=wheel_url
    )
    
    logging.info("📦 Generated universal entry: %s-%s (works on all platforms/Python versions)", 
                normalized_name, wheel.version)
    
    return nix_expr, entry_info

def write_nix_files(output_entries: Dict[str, List[str]], output_dir: str, python_versions: Optional[List[str]] = None) -> List[str]:
    """Write Nix attribute set files for each platform"""
    os.makedirs(output_dir.rstrip('/'), exist_ok=True)
    written_files = []
    
    for platform, entries in output_entries.items():
        # Sort entries for determinism
        body = "\n\n".join(sorted(entries))
        
        # Include buildPythonPackage, fetchurl, configured Python versions, and ... for extra arguments
        if python_versions is None:
            python_versions = ['311', '312', '313']
        python_params = [f"python{version}Packages" for version in sorted(python_versions)]
        all_params = ["buildPythonPackage", "fetchurl"] + python_params + ["..."]
        header = "{ " + ", ".join(all_params) + " }:"
        
        file_content = header + "\n{\n" + body + "\n}\n"
        
        out_path = f"{output_dir.rstrip('/')}/{platform}.nix"
        with open(out_path, "w") as f:
            f.write(file_content)
        
        written_files.append(out_path)
        logging.info("📦 Wrote %s (%d entries)", out_path, len(entries))
    
    return written_files

def write_universal_file(universal_entries: List[str], output_dir: str) -> Optional[str]:
    """Write universal wheels file for pythonPackagesExtensions"""
    if not universal_entries:
        return None
        
    os.makedirs(output_dir.rstrip('/'), exist_ok=True)
    
    # Sort entries for determinism
    body = "\n".join(sorted(universal_entries))
    
    # Format as a pythonPackagesExtensions entry
    file_content = f"""# Universal wheels for pythonPackagesExtensions
# These work across all platforms and Python versions
(
  python-final: python-prev: {{
{body}
  }}
)
"""
    
    out_path = f"{output_dir.rstrip('/')}/universal.nix"
    with open(out_path, "w") as f:
        f.write(file_content)
    
    logging.info("📦 Wrote %s (%d universal entries)", out_path, len(universal_entries))
    return out_path

def format_nix_files(file_paths: List[str]) -> None:
    """Format generated Nix files with alejandra"""
    logging.info("🎨 Formatting generated Nix files with alejandra...")
    
    try:
        for file_path in file_paths:
            result = subprocess.run(['alejandra', file_path], 
                                  capture_output=True, text=True, check=False)
            if result.returncode == 0:
                logging.info("✨ Formatted %s", os.path.basename(file_path))
            else:
                logging.warning("⚠️ Failed to format %s: %s", 
                              os.path.basename(file_path), result.stderr.strip())
    except FileNotFoundError:
        logging.warning("⚠️ alejandra not found in PATH, skipping formatting")
    except Exception as e:
        logging.warning("⚠️ Error during formatting: %s", e)

def output_github_actions_summary(entries: List[GeneratedEntry]) -> None:
    """Generate GitHub Actions outputs if requested"""
    logging.info("📋 Generating GitHub Actions outputs...")
    
    # Generate markdown table
    markdown_table = "| Platform | Python Version | Package | Version | SHA256 (first 12 chars) |\n"
    markdown_table += "|----------|----------------|---------|---------|-------------------------|\n"
    
    sorted_entries = sorted(entries, key=lambda x: (x.platform, x.python_version, x.package_name, x.version))
    
    for entry in sorted_entries:
        short_sha = entry.sha256[:19] if entry.sha256.startswith('sha256-') else entry.sha256[:12]
        markdown_table += f"| {entry.platform} | {entry.python_version} | {entry.package_name} | {entry.version} | `{short_sha}...` |\n"
    
    # Output to GitHub Actions
    github_output_file = os.environ.get('GITHUB_OUTPUT')
    if github_output_file:
        with open(github_output_file, 'a') as f:
            f.write(f"package-count={len(entries)}\n")
            f.write("package-table<<EOF\n")
            f.write(markdown_table)
            f.write("EOF\n")
            
            # Summary statistics
            platforms = set(e.platform for e in entries)
            python_versions = set(e.python_version for e in entries)
            packages = set(f"{e.package_name}-{e.version}" for e in entries)
            
            f.write(f"platforms={', '.join(sorted(platforms))}\n")
            f.write(f"python-versions={', '.join(sorted(python_versions))}\n")
            f.write(f"package-versions={', '.join(sorted(packages))}\n")
    else:
        # Fallback output
        print(f"package-count={len(entries)}")
        print("package-table<<EOF")
        print(markdown_table)
        print("EOF")

def log_summary(entries: List[GeneratedEntry]) -> None:
    """Log a summary of generated entries"""
    logging.info("📊 SUMMARY: Generated (nix-system, python-version, package-version) entries:")
    logging.info("   Total derivations: %d", len(entries))
    logging.info("")
    
    triples = [f"({e.platform}, {e.python_version}, {e.package_name}-{e.version})" for e in entries]
    for triple in sorted(set(triples)):
        logging.info("   📦 %s", triple)

def load_config_from_file(config_path: str) -> Dict[str, Any]:
    """Load configuration from JSON file"""
    try:
        with open(config_path, 'r') as f:
            config = json.load(f)
        logging.info("📋 Loaded configuration from %s", config_path)
        return config
    except FileNotFoundError:
        logging.error("❌ Configuration file not found: %s", config_path)
        sys.exit(1)
    except json.JSONDecodeError as e:
        logging.error("❌ Invalid JSON in configuration file: %s", e)
        sys.exit(1)

def update_package_sources_from_config(config: Dict[str, Any]) -> None:
    """Update global PACKAGE_SOURCES from configuration"""
    global PACKAGE_SOURCES
    
    if 'sources' not in config:
        logging.warning("⚠️ No 'sources' section found in configuration, using defaults")
        return
    
    # Convert Nix-style configuration to Python script format
    sources_config = config['sources']
    updated_sources = {}
    
    for source_name, source_config in sources_config.items():
        # Extract default packages for this source from packages configuration
        default_packages = []
        if 'packages' in config:
            for package_name, package_spec in config['packages'].items():
                if package_spec.get('source') == source_name:
                    # Use wheel_name if specified, otherwise use package name
                    wheel_name = package_spec.get('wheel_name', package_name)
                    default_packages.append(wheel_name)
        
        updated_sources[source_name] = {
            "base_url": source_config['base_url'],
            "default_packages": default_packages,
            "default_version_limit": source_config['default_version_limit'],
            "use_full_url": source_config['use_full_url']
        }
    
    PACKAGE_SOURCES = updated_sources
    logging.info("✅ Updated package sources from configuration: %s", list(PACKAGE_SOURCES.keys()))
    for source_name, source_config in PACKAGE_SOURCES.items():
        logging.debug("   %s: %d packages, limit=%d, url=%s", 
                     source_name, len(source_config['default_packages']), 
                     source_config['default_version_limit'], source_config['base_url'])

# ─── Main Entry Point ─────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="🛠️ Generate Nix expressions for Python wheel packages from various sources",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "-s", "--source",
        help="Package source to use"
    )
    parser.add_argument(
        "-o", "--output-dir",
        default="./nix/wheels",
        help="Directory to write .nix files into"
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable debug logging"
    )
    parser.add_argument(
        "-p", "--packages",
        help="Comma-separated list of packages to process (defaults to source-specific packages)"
    )
    parser.add_argument(
        "--python-versions",
        help="Comma-separated list of Python versions to support (e.g., '311,312,313')"
    )
    parser.add_argument(
        "--version-limit",
        type=int,
        help="Number of latest versions to keep per package (defaults to source-specific limit)"
    )
    parser.add_argument(
        "--github-actions-output",
        action="store_true",
        help="Output package information as GitHub Actions outputs in markdown format"
    )
    parser.add_argument(
        "-n", "--dry-run",
        action="store_true",
        help="Show what would be processed without downloading or writing files"
    )
    parser.add_argument(
        "--config",
        help="Path to configuration file"
    )
    
    args = parser.parse_args()
    setup_logging(args.verbose)
    
    # Load configuration if provided
    if args.config:
        config = load_config_from_file(args.config)
        update_package_sources_from_config(config)
    
    # Set default source if not provided
    if not args.source:
        args.source = list(PACKAGE_SOURCES.keys())[0]
        logging.info("🎯 No source specified, using default: %s", args.source)
    
    # Validate source choice
    if args.source not in PACKAGE_SOURCES:
        logging.error("❌ Unknown source '%s'. Available sources: %s", 
                     args.source, list(PACKAGE_SOURCES.keys()))
        sys.exit(1)
    
    # Get source configuration
    source_config = get_source_config(args.source)
    
    # Use provided packages or defaults from source
    if args.packages:
        target_packages = [pkg.strip() for pkg in args.packages.split(",") if pkg.strip()]
    else:
        target_packages = source_config.default_packages
    
    # Use provided version limit or default from source
    version_limit = args.version_limit if args.version_limit is not None else source_config.default_version_limit
    
    # Parse Python versions from command line
    python_versions = None
    if args.python_versions:
        python_versions = [v.strip() for v in args.python_versions.split(",") if v.strip()]
    
    if args.dry_run:
        logging.info("🎬 DRY RUN: Previewing wheel generation for source '%s'", args.source)
    else:
        logging.info("🎬 Starting wheel generation for source '%s' (output → %s)", args.source, args.output_dir)
    logging.info("🎯 Target packages: %s", target_packages)
    logging.info("🔢 Version limit: %d", version_limit)
    
    try:
        # Get available packages and filter targets
        available_packages = get_available_packages(source_config)
        package_configs = filter_target_packages(available_packages, target_packages, source_config)
        
        # Override version limit in configs
        for config in package_configs:
            config.version_limit = version_limit
        
        # Process each target package
        output_entries: Dict[str, List[str]] = defaultdict(list)
        universal_entries: List[str] = []
        all_generated_entries: List[GeneratedEntry] = []
        
        for config in package_configs:
            try:
                # Get wheels for this package
                wheels = get_wheels_for_package(config.name, config, source_config)
                if not wheels:
                    logging.warning("⚠️ No wheels found for %s", config.name)
                    continue
                
                # Select latest wheels - now returns two collections
                platform_wheels, universal_wheels = select_latest_wheels(wheels, config.version_limit)
                
                total_selected = len(platform_wheels) + len(universal_wheels)
                logging.info("📋 Selected %d wheel combinations for %s (%d platform-specific, %d universal):", 
                           total_selected, config.name, len(platform_wheels), len(universal_wheels))
                
                if args.dry_run:
                    # Dry run: just show what would be processed
                    for (platform, py_ver), wheel in platform_wheels.items():
                        normalized_name = config.name.replace("-", "_")
                        mock_entry = GeneratedEntry(
                            platform=platform,
                            python_version=f"python3.{str(py_ver)[1:]}",
                            package_name=normalized_name,
                            version=str(wheel.version),
                            sha256="[DRY-RUN]",
                            url="[DRY-RUN]"
                        )
                        all_generated_entries.append(mock_entry)
                        logging.info("   📦 Platform-specific: (%s, python3.%s, %s-%s)", 
                                   platform, str(py_ver)[1:], config.name, wheel.version)
                    
                    for version_key, wheel in universal_wheels.items():
                        normalized_name = config.name.replace("-", "_")
                        mock_entry = GeneratedEntry(
                            platform="universal",
                            python_version="all",
                            package_name=normalized_name,
                            version=str(wheel.version),
                            sha256="[DRY-RUN]",
                            url="[DRY-RUN]"
                        )
                        all_generated_entries.append(mock_entry)
                        logging.info("   📦 Universal: (all-platforms, all-python, %s-%s)", 
                                   config.name, wheel.version)
                else:
                    # Generate platform-specific Nix entries
                    for (platform, py_ver), wheel in platform_wheels.items():
                        nix_expr, entry_info = generate_nix_entry(config.name, wheel, source_config)
                        output_entries[platform].append(nix_expr)
                        all_generated_entries.append(entry_info)
                        logging.info("   📦 Platform-specific: (%s, python3.%s, %s-%s)", 
                                   platform, str(py_ver)[1:], config.name, wheel.version)
                    
                    # Generate universal Nix entries  
                    for version_key, wheel in universal_wheels.items():
                        nix_expr, entry_info = generate_universal_entry(config.name, wheel, source_config)
                        universal_entries.append(nix_expr)
                        all_generated_entries.append(entry_info)
                        logging.info("   📦 Universal: (all-platforms, all-python, %s-%s)", 
                                   config.name, wheel.version)
                
            except Exception as e:
                logging.error("⚠️ Error processing %s: %s", config.name, e)
        
        if not args.dry_run and not output_entries and not universal_entries:
            logging.error("❌ No entries generated")
            sys.exit(1)
        
        if args.dry_run:
            logging.info("🏁 DRY RUN complete - no files written")
        else:
            # Write output files
            written_files = write_nix_files(output_entries, args.output_dir, python_versions)
            
            # Write universal wheels file if any
            universal_file = write_universal_file(universal_entries, args.output_dir)
            if universal_file:
                written_files.append(universal_file)
            
            # Format files
            format_nix_files(written_files)
        
        # Generate outputs
        log_summary(all_generated_entries)
        
        if args.github_actions_output and not args.dry_run:
            output_github_actions_summary(all_generated_entries)
        
        if args.dry_run:
            logging.info("🏁 DRY RUN Done! Run without --dry-run to actually download and generate files.")
        else:
            logging.info("🏁 Done!")
        
    except Exception as e:
        logging.error("❌ Failed: %s", e)
        sys.exit(1)

if __name__ == "__main__":
    main()
