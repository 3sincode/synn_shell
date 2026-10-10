# Synn shell architecture — Stage B0 boundary

`shell/Shell.qml` owns the sole Quickshell scene. It creates one `NocturneTokens`, one `ModeController`, one `ApplicationRegistry`, and one `StatusBar`. The bar shows branding, current mode, and a preview label. It exposes no running-app list, shortcut, process operation, radio toggle or authentication UI. It is a Quickshell [`PanelWindow`](https://quickshell.org/docs/v0.2.1/types/Quickshell/PanelWindow/) anchored only top/left/right.

## Implemented contracts

| Component | Input | State/output | Side effects |
|---|---|---|---|
| `ModeController` | `requestMode("Sanctuary"|"Workshop")` | `currentMode`; accepted/rejected signals | **None**. No window arrangement or application operation yet. `autoCloseApplications=false`. |
| `ApplicationRegistry` | `registerApplication(id, category)`, `unregisterApplication(id)` | category lookup and `isProtected`; five approved categories | **None**. In-memory only, no process discovery or shutdown. `automaticTerminationAllowed=false`. |
| `NocturneTokens` | Later preference adapter | Central palette, dimensions, motion durations, reduced-motion/low-power switches | **None**. |
| `StatusBar` | Tokens and mode controller | One top-only visual surface | No task list or edge interaction. |

## Stage B1+ ports, not implemented

| Port / future owner | Required messages and boundary |
|---|---|
| `LauncherController` | `SuperTap`, `ComboUsed`, `Open`, `Search`, `LaunchOrFocus`, `Close`; desktop-entry adapter. Must test modifier suppression and focus. |
| `OverviewController` | `Open`, `Close`, `FocusWindow`, `RestoreWindow`; reads Hyprland toplevel/workspace state; no process termination. |
| `MediaController` | MPRIS metadata, transport, progress; no claim of DSP control. |
| `EqualizerController` + `DspAdapter` | Ten UI values, preset transition, separate DSP `Disconnected/Pending/Applied/Error`. |
| `OrbitalEngine` + `NetworkAdapter`/`BluezAdapter` | Shared radial progress and reversal; adapter reports real state, errors, scans and connection results. |
| `LockCoordinator` + visual lock surface | Secure lock authority and PAM result gate visual state; no decorative overlay can unlock. Validate fail-closed/handoff in a separate test session. |
| `SessionState` / optional shell-only IPC | If needed, user-only Unix socket with explicit schema; no connection to the personal AI project. |

No Stage B0 file imports source from Caelestia, end-4, Serpantinum, or the unlicensed March NixOS tree. The Stage A [component audit](</home/sinn/Synn Dekstop/research/docs/COMPONENT_MATRIX.md>) remains a research reference. Quickshell/Qt/Hyprland version compatibility is not established on this audit host. Do not add an autostart entry or launch this beside Caelestia without an approved preview test.
