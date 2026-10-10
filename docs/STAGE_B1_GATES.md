# Stage B1 prerequisites

1. Review Stage B0 code and choose a disposable preview method on the target Arch machine. Record exact Quickshell, Qt, Hyprland and UWSM versions and current keybindings without changing them.
2. Establish a reproducible static/QML lint environment for the chosen Quickshell revision; validate `qs -p` against `shell/Shell.qml` in an isolated preview, not the active shell session.
3. Implement one launcher and one Overview with desktop-entry/Hyprland adapters. Prove Super tap does not fire on `Super+I/D`, fullscreen and browser focus cases. Validate Alt+Tab and minimized restore without unwanted workspace switch.
4. Add mode layout snapshots and protected registry integration. Test both directions with Auto-Close OFF; terminal, VS Code and Docker workloads remain running. No automatic shutdown API may be introduced.
5. Prove no dock/taskbar or bottom-edge trigger at any state. The bar remains system/status only. No Arena, Gaming mode or `Super+G`.
6. Keep all work in this repository. Any trial session, package installation, UWSM/Hyprland configuration, PAM, service or default-login change requires a separate deployment authorization and rollback runbook.
