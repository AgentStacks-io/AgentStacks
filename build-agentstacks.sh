#!/usr/bin/env bash
# AgentStacks Build Orchestrator
# This script coordinates the entire build process

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
  echo_info "Checking prerequisites..."
  
  local missing=()
  
  # Required tools
  command -v git &> /dev/null || missing+=("git")
  command -v node &> /dev/null || missing+=("node (v22.19+)")
  command -v npm &> /dev/null || missing+=("npm")
  command -v jq &> /dev/null || missing+=("jq")
  
  # Icon building tools
  command -v rsvg-convert &> /dev/null || missing+=("rsvg-convert (librsvg)")
  command -v convert &> /dev/null || missing+=("convert (ImageMagick)")
  command -v icns2png &> /dev/null || missing+=("icns2png (libicns)")
  command -v png2icns &> /dev/null || missing+=("png2icns (libicns)")
  command -v icotool &> /dev/null || missing+=("icotool (icoutils)")
  
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo_error "Missing required tools:"
    printf '  - %s\n' "${missing[@]}"
    echo ""
    echo "Install instructions:"
    echo "  macOS: brew install librsvg imagemagick libicns icoutils jq"
    echo "  Ubuntu: sudo apt-get install librsvg2-bin imagemagick libicns-utils icoutils jq"
    exit 1
  fi
  
  echo_info "All prerequisites met!"
}

# Display usage
usage() {
  cat << EOF
AgentStacks Build Script

Usage: $0 [OPTIONS]

Options:
  -q, --quality <stable|insider>  Build quality (default: stable)
  -a, --arch <x64|arm64>          Architecture (default: auto-detect)
  -i, --icons-only                Only build icons
  -s, --skip-icons                Skip icon generation
  -c, --clean                     Clean build artifacts before building
  -v, --verbose                   Enable verbose output during build
  -h, --help                      Show this help message

Examples:
  $0                              # Build stable release for current platform
  $0 -v                           # Build with verbose output
  $0 -q insider                   # Build insider release
  $0 -i                           # Only regenerate icons
  $0 -c                           # Clean build

EOF
}

# Parse arguments
ICONS_ONLY=false
SKIP_ICONS=false
CLEAN_BUILD=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -q|--quality)
      export VSCODE_QUALITY="$2"
      shift 2
      ;;
    -a|--arch)
      export VSCODE_ARCH="$2"
      shift 2
      ;;
    -i|--icons-only)
      ICONS_ONLY=true
      shift
      ;;
    -s|--skip-icons)
      SKIP_ICONS=true
      shift
      ;;
    -c|--clean)
      CLEAN_BUILD=true
      shift
      ;;
    -v|--verbose)
      VERBOSE=true
      export VERBOSE="yes"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo_error "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

# Main build process
main() {
  echo_info "Starting AgentStacks Build Process"
  echo "=================================="
  
  check_prerequisites
  
  # Clean if requested
  if [[ "$CLEAN_BUILD" == "true" ]]; then
    echo_info "Cleaning build artifacts..."
    rm -rf vscode/.build
    rm -rf vscode/out-*
    rm -rf src/stable/resources/
    rm -rf src/insider/resources/
    echo_info "Clean complete!"
  fi
  
  # Load version configuration
  echo_info "Loading version configuration..."
  . ./version.sh
  
  # Icons only mode
  if [[ "$ICONS_ONLY" == "true" ]]; then
    echo_info "Building icons only..."
    cd icons
    ./build_icons.sh
    cd ..
    echo_info "Icon build complete!"
    exit 0
  fi
  
  # Build icons unless skipped
  if [[ "$SKIP_ICONS" != "true" ]]; then
    echo_info "Building icons..."
    cd icons
    ./build_icons.sh
    cd ..
  else
    echo_warn "Skipping icon generation"
  fi
  
  # Get VS Code source
  if [[ ! -d "vscode/.git" ]]; then
    echo_info "Fetching VS Code source..."
    . ./get_repo.sh
  else
    echo_info "VS Code source already present, loading version info..."
    . ./get_repo.sh
  fi
  
  # Build
  echo_info "Starting build process..."
  if [[ "$VERBOSE" == "true" ]]; then
    echo_info "Verbose mode enabled - you'll see all build output"
  fi
  . ./build.sh
  
  echo ""
  echo_info "=================================="
  echo_info "Build complete!"
  echo_info "Release version: ${RELEASE_VERSION}"
  echo_info "Platform: ${OS_NAME}-${VSCODE_ARCH}"
  
  # Display output location
  if [[ "${OS_NAME}" == "osx" ]]; then
    echo_info "Output: AgentStacks-darwin-${VSCODE_ARCH}/"
  elif [[ "${OS_NAME}" == "linux" ]]; then
    echo_info "Output: AgentStacks-linux-${VSCODE_ARCH}/"
  elif [[ "${OS_NAME}" == "windows" ]]; then
    echo_info "Output: AgentStacks-win32-${VSCODE_ARCH}/"
  fi
}

# Run main
main "$@"