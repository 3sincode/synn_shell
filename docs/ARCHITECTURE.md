# Synn shell architecture — Stage B1

`shell/Shell.qml` is the sole `ShellRoot`. It owns one shared `StatusBar`, one launcher overlay, one Overview overlay, and the controller/adapter instances. Sanctuary and Workshop change presentation within this single shell instance. There is no app list in the bar, dock, taskbar, bottom-edge trigger, process shutdown, or system service operation.

| Boundary | Implemented behavior | Limit |
|---|---|---|
| `HyprlandAdapter` | Owns shortcut declarations, modifier-tap state, toplevel inventory, exact-address focus dispatch and event refresh. | Real binding arbitration, dispatch acknowledgment and focus semantics need an isolated Hyprland trial. |
| `LauncherController` | Filters `DesktopEntries.applications.values`, wraps arrow-key selection, focuses an exact startup-class match or invokes a desktop entry. | Terminal desktop entries are blocked until a terminal adapter exists. Launch success is not acknowledged. |
| `LauncherOverlay` | Search-first transient panel; Esc, Enter, arrows, mouse and focus retry; reversible fade/scale. | Global shortcut and keyboard-grab behavior are untested. Topbar “Apps” is a fallback control. |
| `OverviewController` | Closed/Opening/Open/Closing state, current window inventory, selection and stale-address rejection. | Selection sends focus dispatch; it does not prove focus was granted. |
| `OverviewOverlay` | Window cards with title, monitor/workspace, optional still screencopy and explicit fallback; keyboard and mouse selection. | Screencopy support and preview freshness require runtime validation. |
| `ModeController` | Exactly Sanctuary/Workshop, calm/work presentation profiles, Auto-Close OFF. | Physical window layout remains unchanged. |
| `WindowLayoutController` | Validated, in-memory window geometry snapshots; explicit failed restore contract. | No move/minimize/restore dispatch until trial evidence supports a safe policy. |
| `ApplicationRegistry` | Five categories; terminal, Docker, container and database kinds become protected. | In-memory interface; no process discovery or termination. |
| `MotionTokens` | Shared durations, hidden scale, reduced-motion and low-power values. | 144 Hz smoothness is not benchmarked. |

Opening the launcher closes Overview and vice versa. Closing with Esc or backdrop requests restoration of the previously focused window. Selecting an app/window suppresses that restoration. Overlay phase transitions can reverse; timers complete only the current phase. Hidden panels stop focus retry, and still previews avoid continuous capture.

The only compositor mutation in this stage is an explicit user-requested focus dispatch. Mode switching only records a snapshot and updates Synn presentation. A snapshot is neither proof of a restorable layout nor a compositor transaction. `restore()` reports a failure until the isolated trial defines and validates workspace, monitor, floating, minimized and focus rules.

API references for Quickshell 0.3.2: [DesktopEntries](https://quickshell.org/docs/v0.3.2/types/Quickshell/DesktopEntries/), [DesktopEntry](https://quickshell.org/docs/v0.3.2/types/Quickshell/DesktopEntry/), [GlobalShortcut](https://quickshell.org/docs/v0.3.2/types/Quickshell.Hyprland/GlobalShortcut/), [Hyprland](https://quickshell.org/docs/v0.3.2/types/Quickshell.Hyprland/Hyprland/), [HyprlandToplevel](https://quickshell.org/docs/v0.3.2/types/Quickshell.Hyprland/HyprlandToplevel/), [ScreencopyView](https://quickshell.org/docs/v0.3.2/types/Quickshell.Wayland/ScreencopyView/), and [PanelWindow](https://quickshell.org/docs/v0.3.2/types/Quickshell/PanelWindow/). These establish documented API shape, not successful loading on this host. The [Stage A component audit](</home/sinn/Synn Dekstop/research/docs/COMPONENT_MATRIX.md>) informed the boundaries; no upstream code was copied.
