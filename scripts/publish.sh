#!/bin/bash

# publish.sh - Update homebrew-tap formula with new gcx version
# Usage: ./scripts/publish.sh <version>
# Example: ./scripts/publish.sh 1.1.0

set -e

cd "$(dirname "$0")/.."

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    echo -e "${RED}Usage: ./scripts/publish.sh <version>${NC}"
    echo "Example: ./scripts/publish.sh 1.1.0"
    exit 1
fi

TARBALL_URL="https://github.com/cirrus-tools/gcx/archive/refs/tags/v${VERSION}.tar.gz"
FORMULA="Formula/gcx.rb"

echo -e "${BLUE}Publishing gcx v${VERSION} to homebrew-tap${NC}"
echo ""

# Download and calculate sha256
echo -e "${BLUE}Downloading tarball...${NC}"
TMPFILE=$(mktemp)
if ! curl -sL "$TARBALL_URL" -o "$TMPFILE"; then
    echo -e "${RED}Failed to download: ${TARBALL_URL}${NC}"
    rm -f "$TMPFILE"
    exit 1
fi

# Check if file is valid (not a 404 page)
if file "$TMPFILE" | grep -q "HTML"; then
    echo -e "${RED}Error: Got HTML instead of tarball. Tag v${VERSION} may not exist.${NC}"
    rm -f "$TMPFILE"
    exit 1
fi

SHA256=$(shasum -a 256 "$TMPFILE" | cut -d' ' -f1)
rm -f "$TMPFILE"

echo -e "${GREEN}SHA256: ${SHA256}${NC}"
echo ""

# Update formula
echo -e "${BLUE}Updating ${FORMULA}...${NC}"
sed -i '' "s|/tags/v[0-9]*\.[0-9]*\.[0-9]*\.tar\.gz|/tags/v${VERSION}.tar.gz|" "$FORMULA"
sed -i '' "s/sha256 \".*\"/sha256 \"${SHA256}\"/" "$FORMULA"
sed -i '' "s/version \"[0-9]*\.[0-9]*\.[0-9]*\"/version \"${VERSION}\"/" "$FORMULA"

# Show diff
echo -e "${BLUE}Changes:${NC}"
git diff "$FORMULA"
echo ""

# Confirm
read -p "Commit and push? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted. You can manually commit the changes."
    exit 0
fi

# Commit and push
git add "$FORMULA"
git commit -m "gcx: update to v${VERSION}"
git push origin main

echo ""
echo -e "${GREEN}Published gcx v${VERSION} to homebrew-tap${NC}"
echo ""
echo -e "${YELLOW}Users can now install/upgrade:${NC}"
echo "  brew tap cirrus-tools/tap"
echo "  brew install gcx"
echo "  brew upgrade gcx"
echo ""
