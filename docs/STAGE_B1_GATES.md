# Stage B1 runtime trial plan — approval required before live testing

No command in this section has been run for this preparation. KDE stays active; no Synn autostart, lock, UWSM launch, service change, or write to `~/.config/hypr` is involved. Use the exact repository files, not a copied user config.

## Gate 1: ordinary Quickshell window under KDE

After approval, from a KDE terminal, run:

```sh
cd /home/sinn/Projects/synn-shell
./scripts/run_smoke_kde.sh
```

The script rejects a non-KDE or Hyprland environment and runs `qs -p` on `smoke/Smoke.qml`. That QML creates exactly one `FloatingWindow`; it has no panel, global shortcut, Hyprland adapter, session lock, or process launch. Expected result: a small “Synn smoke test” window. Risk: a Quickshell/Qt crash or ordinary focus change in KDE. Rollback: `Ctrl+C` in the same terminal; if the window persists, terminate only that `qs -p .../smoke/Smoke.qml` process after confirming its PID. Do not run `shell/Shell.qml` under KDE.

## Gate 2: determine whether nesting is safe

Before a nested launch, record the actual `Hyprland --version`, `qs --version`, `pacman -Q aquamarine`, current `WAYLAND_DISPLAY`, GPU/driver, and whether the installed Aquamarine build can be constrained to its Wayland backend without a DRM fallback. Inspect `Hyprland --help` and the installed Aquamarine/Hyprland documentation or source for that exact build. **If backend confinement cannot be proven, do not launch nested Hyprland under KDE.**

Aquamarine includes a Wayland-in-window backend, so nesting is plausible. It is not guaranteed on this machine: an [upstream Aquamarine 0.14.0 report](https://github.com/hyprwm/aquamarine/issues/348) describes a nested Hyprland 0.56.1 output that stops presenting after its first frame. The installed Aquamarine version and KDE-host behavior are unknown in this preparation environment. A fallback to DRM could also threaten the active display; a nested test must never reach that backend.

`config/hyprland/trial/hyprland.lua` is an isolated `--config` candidate. It requests only `WAYLAND-1` at 1280×800 and disables unmatched outputs, suppresses systemd/DBus environment export, starts no clients, and has `Super+Shift+Escape` mapped to `hl.dsp.exit()`. The fallback monitor rule does not replace backend confinement. The exit dispatcher is appropriate only for a standalone nested trial, never for a UWSM session. This config intentionally does not load `synn-b1-review.lua`.

**Candidate command, NOT APPROVED TO RUN YET** (only after confirming backend confinement and receiving approval):

```sh
env -u HYPRLAND_INSTANCE_SIGNATURE HYPRLAND_NO_SD_VARS=1 \
  Hyprland --config /home/sinn/Projects/synn-shell/config/hyprland/trial/hyprland.lua
```

Risk: the nested window may be black, frozen, or fail to start; without a proven backend constraint, it may attempt DRM. Rollback, in order: focus the nested window and press `Super+Shift+Escape`; use `Ctrl+C` in the launching terminal; if necessary, send `TERM` only to the exact recorded nested Hyprland PID. Never use broad process matching, `uwsm stop`, logout, or reboot as a rollback for this trial.

## Gate 3: Synn interaction matrix in an isolated session

Only after Gates 1–2 pass, run one Synn shell instance on the nested display and separately review loading `synn-b1-review.lua`. Keep the Super-only bind disabled until every collision case passes. Record PASS/FAIL per item:

| Area | Cases to prove |
|---|---|
| Launcher | Desktop-entry search and ranking, typing focus, arrows, Enter focus/launch, Esc restore, terminal-entry rejection, launch failure, held/repeated Super, Super+I/D/Tab, unrelated Super combinations, fullscreen, focus-grab failure. |
| Overview | Zero/one/many windows, mouse and keyboard choice, multi-workspace/monitor labels, stale-window removal, missing screencopy fallback, rapid open/close reversal, preview freshness, return animation. |
| Focus | Exact-address dispatch acknowledgment, already-running app match, cancellation restore, minimized/fullscreen windows, no unwanted workspace switch. |
| Modes | Sanctuary↔Workshop presentation, snapshot failure handling, no automatic window move or app launch, no termination or restart, protected/pinned app treatment. |
| Preservation | Keep existing terminals, unsaved editor work, Docker, containers and databases running throughout; verify no process or service change. |
| Visual/performance | One top bar, no dock/taskbar/edge reveal, reduced-motion and low-power paths, animation interruption cleanup, measured 1920×1080/144 Hz frame timing. |

Alt+Tab and physical layout restoration are not implemented by this repository. Their policies need separate compositor testing and review before enabling them.
