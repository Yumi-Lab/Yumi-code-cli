#!/bin/sh
# YUMI-C GODMODE installer (experimental) — detects the platform and installs
# the yumi-c binary built with the --permission-mode godmode feature.
#
# This is a SEPARATE, experimental build — not the stable `yumi` CLI installed
# by install.sh. It targets the v0.1.1-godmode pre-release specifically
# (GitHub's "latest" release alias skips pre-releases, so this script always
# pins an explicit tag rather than following /releases/latest).
#
# See GODMODE.md in this repo for what the feature does and how to use it.
set -e

REPO="Yumi-Lab/Yumi-code-cli"
TAG="v0.1.1-godmode"

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

asset="yumi-c-$os-$arch"
if [ "$os" = "windows" ]; then
  if [ "$arch" != "amd64" ]; then echo "Unsupported platform: $OS/$ARCH" >&2; exit 1; fi
  asset="yumi-c-windows-amd64.exe"
fi
url="https://github.com/$REPO/releases/download/$TAG/$asset"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
echo "Downloading $asset ($TAG) ..."
curl -fsSL "$url" -o "$tmp"
chmod +x "$tmp"

# Installed under a distinct name (yumi-c-godmode) so it never silently
# shadows a stable yumi-c install — this build is experimental.
dest="/usr/local/bin/yumi-c-godmode"
if [ "$os" = "windows" ]; then
  dest="$HOME/bin/yumi-c-godmode.exe"
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
  dest="$HOME/.local/bin/yumi-c-godmode"
  mkdir -p "$(dirname "$dest")"
  mv "$tmp" "$dest"
  echo "Note: make sure $HOME/.local/bin is in your PATH."
fi
trap - EXIT

echo "Installed: $dest"
"$dest" --version
echo ""
echo "Try it: $dest -p 'reply with exactly: pong' --permission-mode godmode"
