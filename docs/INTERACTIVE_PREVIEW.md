# Synn Interactive Preview — KDE window only

The preview is a separate Quickshell entrypoint at repository-root `Preview.qml`, keeping shared component imports inside its Quickshell root. Its implementation is under `preview/`. It opens one ordinary `FloatingWindow` in KDE. It does not import the Hyprland adapter, register global shortcuts, create a desktop panel, connect to real window inventory, lock the session, or start applications. All entries, windows, focus results, workspaces and monitors come from `preview/MockCompositor.qml`.

It reuses the production `LauncherController`, `OverviewController`, `ModeController`, `MotionTokens`, `NocturneTokens` and pure interaction rules. The production controller gains generic entry injection and an execution gate, retaining its normal defaults. The preview overrides entries with mock data, disables external execution, and uses a mock adapter launch method. Preview visuals live entirely under `preview/` because production launcher/Overview visuals are compositor `PanelWindow`s.

## After separate approval: run and exit

```sh
cd /home/sinn/Projects/synn-shell
./scripts/run_interactive_preview.sh
```

The launcher checks for KDE/Plasma, rejects a Hyprland environment, and runs only the explicit preview file path. It disables Quickshell file watching for this process. Exit safely with **Ctrl+C in that terminal**. If that fails, identify and terminate only the `qs -p .../Preview.qml` PID. This command has **not** been run by this task.

## Controls and expected behavior

| Action | Preview validation |
|---|---|
| Sanctuary / Workshop buttons or Ctrl+1 / Ctrl+2 | Shared mode controller changes the mock presentation and accent. No window or process is moved or closed. |
| Launcher button or Ctrl+L | Launcher controller opens, filters four mock desktop entries as text is typed, wraps arrow selection, and handles Enter/Escape. Enter focuses an existing mock window or asks the mock adapter to add one. External execution is disabled. |
| Overview button or Ctrl+O | Overview controller shows synthetic windows across two mock workspaces and monitors. Mouse/arrow selection changes only the mock focused address. |
| Reverse motion button or Ctrl+R | Reverses the currently opening/closing launcher or Overview state; timer completion follows the latest phase. |
| Reduced motion / Low power buttons | Exercise shared duration and scale token paths. |
| Add / Remove mock window | Exercise Overview refresh and stale-window selection handling without touching a real window. |

Use the visible buttons if KDE or another surface captures a shortcut. Keyboard shortcuts work only while this ordinary preview window has focus; they are not system bindings.

## Safe checks

```sh
./scripts/check_interactive_preview.sh
git diff --check
```

The check script runs repository invariants, shell syntax, Node state tests when `node` is available, and preview QML lint when `qmllint` is available. A missing tool is reported **NOT TESTED**. It does not open a window.

## Limits

Preview PASS can validate QML loading on KDE, mock search/navigation, controller state reversal, visual timing, and mock focus/window refresh. It cannot validate Hyprland global shortcut delivery or Super-tap collisions; real desktop entries or app launches; compositor window focus, fullscreen/minimized/workspace behavior; live screencopy; layer-shell focus and topbar behavior; physical mode layout restore; process preservation under a real session; or 144 Hz compositor frame timing. Those remain isolated Hyprland-session gates.
