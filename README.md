# YUMI CODE

Terminal coding agent by Yumi Lab. One static binary, zero dependencies,
runs everywhere - from a 1 GB ARM board to your workstation.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/Yumi-code-cli/main/install.sh | sh
```

The installer detects your platform automatically. Manual downloads are on the
[releases page](https://github.com/Yumi-Lab/Yumi-code-cli/releases/latest).

## Supported platforms

| Platform | Binary |
|---|---|
| Linux x86_64 | `yumi-linux-amd64` |
| Linux ARM 64-bit (aarch64) | `yumi-linux-arm64` |
| Linux ARM 32-bit (armhf, armv7) | `yumi-linux-armhf` |
| macOS Apple Silicon | `yumi-darwin-arm64` |
| macOS Intel | `yumi-darwin-amd64` |

## Usage

```sh
yumi                  # interactive TUI
yumi -p "your task"   # one-shot headless run
yumi --help           # all options
```

Authentication uses your existing Claude Pro/Max subscription (OAuth). No API
key is required; existing credentials on the machine are read, never modified.

## Verify a download

```sh
shasum -a 256 -c SHA256SUMS
```

## Footprint

- Binary: ~14 MB, statically linked
- Runtime: ~20 MB RSS per agent session
- Cold start: ~30 ms (Apple Silicon), ~200 ms (armv7 SBC)

## License

Copyright Yumi Lab. All rights reserved. The binaries are free to download
and use. The source code is not published at this stage.
