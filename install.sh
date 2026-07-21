#!/bin/sh
# YUMI CODE installer - detects the platform and installs the right binary.
set -e

REPO="Yumi-Lab/Yumi-code-cli"

OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  Linux)  os=linux ;;
  Darwin) os=darwin ;;
  MINGW*|MSYS*|CYGWIN*) os=windows ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64|amd64)        arch=amd64 ;;
  aarch64|arm64)       arch=arm64 ;;
  armv7l|armv6l|armhf) arch=armhf ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

if [ "$os" = "darwin" ] && [ "$arch" = "armhf" ]; then
  echo "Unsupported platform: $OS/$ARCH" >&2; exit 1
fi

asset="yumi-$os-$arch"
if [ "$os" = "windows" ]; then
  if [ "$arch" != "amd64" ]; then echo "Unsupported platform: $OS/$ARCH" >&2; exit 1; fi
  asset="yumi-windows-amd64.exe"
fi
url="https://github.com/$REPO/releases/latest/download/$asset"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo "Downloading $asset ..."
curl -fsSL "$url" -o "$tmp"
chmod +x "$tmp"

dest="/usr/local/bin/yumi"
if [ "$os" = "windows" ]; then
  dest="$HOME/bin/yumi.exe"
  mkdir -p "$HOME/bin"
  mv "$tmp" "$dest"
  trap - EXIT
  echo "Installed: $dest (experimental build - requires Git Bash or WSL)"
  "$dest" --version
  exit 0
fi
if [ -w "$(dirname "$dest")" ]; then
  mv "$tmp" "$dest"
elif [ -t 0 ] && command -v sudo >/dev/null 2>&1; then
  echo "Installing to $dest (sudo required)"
  sudo mv "$tmp" "$dest"
elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  sudo mv "$tmp" "$dest"
else
  dest="$HOME/.local/bin/yumi"
  mkdir -p "$(dirname "$dest")"
  mv "$tmp" "$dest"
  echo "Note: make sure $HOME/.local/bin is in your PATH."
fi
trap - EXIT

echo "Installed: $dest"
"$dest" --version
