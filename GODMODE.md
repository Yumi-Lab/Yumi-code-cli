# yumi-c GodMode (experimental)

`yumi-c` is Yumi Code's verbatim Go clone of the Claude Code CLI. **GodMode** is an experimental
fifth permission mode — a peer of `default`/`acceptEdits`/`bypassPermissions`/`plan`/`dontAsk`/`auto` —
for delegating tasks too large for a single context window.

**Status: beta / experimental.** Not part of the stable `yumi` release line (see the main
[README](./README.md) / `install.sh` for that). Built from a dedicated experimental branch and
distributed here as pre-release `v0.1.1-godmode`, `yumi-c` only.

## What it does

Activating GodMode (`--permission-mode godmode`) turns the current instance into an *orchestrator*:
its only job is to arm an autonomous coding loop for the task, then hand off and stop. It never does
the task's work itself. The loop it arms spawns ordinary coder/reviewer instances in normal
autonomous (`bypassPermissions`) mode — never in GodMode themselves. One instance per run is ever
"the orchestrator"; there's no role to configure and no recursion risk.

The loop mechanics are not reimplemented — `yumi-c` vendors a real autonomous coding loop (bash,
proven in production) directly into the binary, extractable on demand. Nothing about GodMode requires
network access to a third-party kit repository at runtime.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Yumi-Lab/Yumi-code-cli/main/install-godmode.sh | sh
```

Installs `yumi-c-godmode` (a distinct binary name, so it never shadows a stable `yumi-c` install).
Supports linux/amd64, linux/arm64, linux/armhf (armv7, e.g. Smart Pi-class devices), darwin/amd64,
darwin/arm64, windows/amd64. Manual download + `SHA256SUMS` also available on the
[v0.1.1-godmode release page](https://github.com/Yumi-Lab/Yumi-code-cli/releases/tag/v0.1.1-godmode).

## Use

```sh
# One-shot, headless
yumi-c-godmode -p "<task description>" --permission-mode godmode

# Or select it interactively (Shift+Tab / /permissions) in the TUI
yumi-c-godmode
```

On activation, the orchestrating instance will: write a falsifiable `GOAL.md`/`PROGRESS.md` for the
task, extract its own vendored loop kit into the task directory (`yumi-c-godmode godmode-extract-kit
<dir>`), start the loop detached with a verified liveness check, record `.monitor/owner.json`
(`{"agent_id", "source", "label", "started_at"}` — `agent_id` is optional and opaque; supply one via
input if your integration needs attribution), then stop. From there the loop runs coder/reviewer
iterations to completion on its own.

## Integrating from an external system (e.g. a gateway/orchestrator)

- **No special protocol support needed to invoke it.** `yumi-c-godmode` is a normal CLI: spawn it,
  give it a prompt, let it exit. Nothing about GodMode changes how you already invoke `yumi-c` for a
  one-shot task.
- **Identity is optional and opaque.** If your system has its own agent/task identity, you can pass it
  through as input (flag/env) and it will be copied verbatim into `.monitor/owner.json` inside the task
  directory — `yumi-c` does not interpret, validate, or require any particular format.
- **No outbound dependency at runtime.** The loop kit is embedded in the binary; nothing is fetched
  from a third-party repository when GodMode arms a task.
- **This binary alone never talks to any orchestration/messaging layer.** If your system has (or plans)
  an agent-to-agent / task-delegation protocol, that lives entirely on your side — `yumi-c-godmode`
  itself has no client or server for it and needs no changes to interoperate with one.

## Feedback / issues

This is an experimental pre-release. Report problems against the `Yumi-Lab/yumi-code-cli-sourcecode`
repository (branch `experiment/godmode-yumi-c`) if you have access, or through your usual Yumi Lab
contact otherwise.
