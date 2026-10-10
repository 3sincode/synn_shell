# Stage B1 status and runtime preparation

Branch: `feat/stage-b1-desktop-interactions`; draft PR #1. Source-only preparation; no live compositor test or deployment.

## Results as of 2026-10-10

| Check | Result | Evidence and limit |
|---|---|---|
| Stage B1 architecture/static invariants | PASS | `python3 scripts/check_stage_b1.py` on this revision; checks one shell/bar, two modes, protected registry, Lua bind file and inert smoke/trial files. |
| Node interaction state machines | PASS | `node --test tests/interaction.test.mjs`: 5/5 on this revision. |
| QML lint for prior 12 Stage B1 QML files | PASS, user-reported | User supplied 12/12 result before this preparation. It was not reproduced on this host, and the new smoke QML has not been linted. |
| Quickshell/Hyprland documented API forms | PASS, source review | Quickshell 0.3.2 `GlobalShortcut`, `Hyprland.usingLua`/`dispatch`, `FloatingWindow`; Hyprland 0.56 Lua `hl.bind`, `hl.dsp.global`, `hl.dsp.focus`, `hl.monitor`, `hl.dsp.exit`. This is documentation compatibility, not runtime proof. |
| Installed tool discovery on this authoring host | FAIL | `Hyprland`, `qs`, `qmllint`, `pacman`, `lua` and `luac` were not in `PATH`; `/usr/bin/Hyprland`, `/usr/bin/qs`, `/usr/bin/qmllint`, `/usr/bin/hyprctl` were absent. The user's target installation cannot be inspected from this host. |
| Lua syntax with `luac` or Hyprland parser | NOT TESTED | No Lua/Hyprland executable available here. Static patterns do not prove parser acceptance. |
| KDE Quickshell smoke window | NOT TESTED | Prepared but requires later live-test approval. |
| Nested Hyprland/Aquamarine on KDE | NOT TESTED | Installed Aquamarine version/backend confinement not verifiable here; upstream has a nested-output stall report for 0.14.0. |
| Super-only modifier collision matrix | NOT TESTED | Bind remains commented out. Shell arbiter covers only events delivered to it. |
| Launcher, Overview, focus, mode and window preservation runtime | NOT TESTED | Requires isolated compositor test. |
| `git diff --check` | PASS | Checked for this preparation commit. |

## Source implementation and limits

The existing launcher, Overview, Sanctuary/Workshop presentation and protected registry remain. This preparation replaces the obsolete `.conf` candidate with a Hyprland 0.56 Lua module, updates focus requests to the Lua dispatcher form, adds a non-panel Quickshell smoke window, and stages a minimal nested config without loading Synn binds. No application is automatically closed, and mode changes do not move windows. Successful focus, preview freshness, keyboard grabbing, physical layout restore, Alt+Tab and measured motion remain unverified.

See `STAGE_B1_GATES.md` for proposed commands, risks, rollback and the interaction checklist. No Stage C or lockscreen work is included.
