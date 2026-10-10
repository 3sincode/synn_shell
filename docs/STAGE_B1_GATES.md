# Stage B1 isolated runtime trial gates

Stage B1 source is not installed. Keep the active KDE session intact. A later trial needs separate approval and a disposable Hyprland session or equivalent isolation that cannot replace the current desktop or affect user processes.

1. Record the target Quickshell 0.3.2, Qt, Hyprland 0.56.2 and UWSM 0.27.0 versions and existing shortcuts. Run QML syntax/import validation with those exact packages. Resolve every QML error before interaction testing.
2. Review `config/hyprland/synn-b1-review.conf` against actual bindings. The Super-only candidate is intentionally commented out: establish compositor-side press/release semantics and suppression for **all** Super combinations before enabling it. Verify tap, hold, repeat, Super+I, Super+D, Super+Tab, unrelated Super combinations, fullscreen apps and keyboard grabs. Keep the topbar fallback usable.
3. Test launcher desktop-entry discovery, typing focus, arrows, Enter, Esc, closing focus restoration, already-running app matching, launch failures, terminal entries and multiple workspaces. Confirm no stray toggle or focus theft.
4. Test Overview with zero, one and many windows across monitors/workspaces; mouse and keyboard selection; rapid open/close reversal; stale/closed windows; missing capture protocol; preview permission or capture failure; fullscreen and focus-grab failure. Confirm no stale image is displayed.
5. Test both mode directions with terminal sessions, unsaved editor work and Docker/database workloads running. Verify no termination, restart or workspace jump. Define and separately review a physical layout restore policy before enabling window movement. Snapshot validation alone does not pass this gate.
6. Check one shell/root/bar, dockless and taskbarless behavior, bottom-edge inactivity, reduced-motion and low-power paths, frame timing on 1920×1080 at 144 Hz, and cleanup after interrupted animations. Do not claim a measured frame rate until benchmarked.
7. Keep a rollback path to the existing desktop and shell. Do not autostart Synn, source the keybind fragment, change Hyprland/UWSM/KDE settings, install services or deploy a lockscreen as part of this source review.

An `Alt+Tab` binding and minimized-window restore policy are not installed by this repository. They require validation in the isolated compositor trial, with no forced workspace switch.
