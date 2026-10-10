# Stage B1 status and runtime preparation

Branch: `feat/stage-b1-desktop-interactions`; draft PR #1. Source-only preparation; no live compositor test or deployment.

## Results as of 2026-10-10

| Check | Result | Evidence and limit |
|---|---|---|
| Stage B1 architecture/static invariants | PASS | `python3 scripts/check_stage_b1.py` on this revision; checks one shell/bar, two modes, protected registry, Lua bind file and inert smoke/trial files. |
| Node interaction state machines | PASS | `node --test tests/interaction.test.mjs`: 5/5 on this revision. |
| QML lint for prior 12 Stage B1 QML files | PASS, user-reported | User supplied 12/12 result on the target machine. It was not reproduced on this authoring host. |
| Quickshell/Hyprland documented API forms | PASS, source review | Quickshell 0.3.2 `GlobalShortcut`, `Hyprland.usingLua`/`dispatch`, `FloatingWindow`; Hyprland 0.56 Lua `hl.bind`, `hl.dsp.global`, `hl.dsp.focus`, `hl.monitor`, `hl.dsp.exit`. This is documentation compatibility, not runtime proof. |
| Target versions | PASS, user-reported | Hyprland 0.56.2, Aquamarine 0.15.1 and Quickshell 0.3.2 on Arch KDE Wayland. |
| Installed tool discovery on this authoring host | FAIL | `Hyprland`, `qs`, `qmllint`, `pacman`, `lua` and `luac` were not in `PATH`; `/usr/bin/Hyprland`, `/usr/bin/qs`, `/usr/bin/qmllint`, `/usr/bin/hyprctl` were absent. The target installation cannot be inspected from this host. |
| Trial Lua config and shortcut syntax on target | PASS, user-reported | Target machine reported `config ok` and valid shortcut Lua syntax. No compositor was started in this task. |
| KDE Quickshell smoke window | PASS, user-reported | The earlier ordinary-window smoke test succeeded on the target machine. |
| Nested Hyprland/Aquamarine on KDE | NOT TESTED | Aquamarine 0.15.1 is reported on target; nested behavior and backend confinement remain unverified. |
| Super-only modifier collision matrix | NOT TESTED | Bind remains commented out. Shell arbiter covers only events delivered to it. |
| Launcher, Overview, focus, mode and window preservation runtime | NOT TESTED | Requires isolated compositor test. |
| `git diff --check` | PASS | Checked for the interactive-preview changes. |
| Interactive preview static isolation | PASS | Source checks require a `FloatingWindow`, mock entries and controllers, and reject panels, global shortcuts, Hyprland imports and session lock types in preview QML. |
| Interactive preview QML lint | NOT TESTED | `qmllint` is not available on this authoring host; target machine must lint the entrypoint and four preview QML files. |
| Interactive preview launch under KDE | NOT TESTED | Prepared only; the user requested no automatic launch. |

## Source implementation and limits

The existing launcher, Overview, Sanctuary/Workshop presentation and protected registry remain. This preparation replaces the obsolete `.conf` candidate with a Hyprland 0.56 Lua module, updates focus requests to the Lua dispatcher form, adds a non-panel Quickshell smoke window, and stages a minimal nested config without loading Synn binds. No application is automatically closed, and mode changes do not move windows. Successful focus, preview freshness, keyboard grabbing, physical layout restore, Alt+Tab and measured motion remain unverified.

See `STAGE_B1_GATES.md` for proposed commands, risks, rollback and the interaction checklist. No Stage C or lockscreen work is included.

The separate `INTERACTIVE_PREVIEW.md` explains what mock interaction tests can prove and what remains dependent on a real Hyprland session.
