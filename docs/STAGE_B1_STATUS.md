# Stage B1 implementation status

Branch: `feat/stage-b1-desktop-interactions`. Baseline: Stage B0 commit `6a73eee62331192a86a2704c53d751f05b424034`.

## Implemented in source

- One root, one top bar, two transient panels; no dock, taskbar or edge trigger.
- Searchable desktop-entry launcher with arrow selection, Enter action, Esc dismissal, a guarded terminal-entry path and focus retry.
- Explicit Super-tap state rules that suppress repeats, long holds and observed combinations; adapter-owned global shortcut names and a review-only compositor fragment.
- Reversible launcher/Overview `Closed → Opening → Open → Closing → Closed` states, shared motion timing, reduced-motion and low-power flags.
- Overview inventory, mouse/keyboard selection, monitor/workspace labels, optional still screencopy and visible fallback.
- Sanctuary and Workshop presentation profiles with no automatic application termination. In-memory window snapshot validation and a restore contract that reports its current gating failure.
- Five-category application registry with protected workload kinds.

## Incomplete / NOT RUNTIME TESTED

- QML syntax/import loading, keyboard grabs, global-shortcut press/release delivery and Super-only arbitration across arbitrary compositor shortcuts. The Super-only line remains commented out in the review fragment.
- Successful desktop-entry launch, application-class matching, focus dispatch acknowledgment and focus restoration, including fullscreen/minimized cases.
- Screencopy protocol availability, preview validity and visual frame smoothness. Still captures are attempted; the fallback remains visible when no content exists.
- Actual compositor window placement and snapshot restoration. Mode transitions change only Synn presentation and never move user windows. Alt+Tab/minimized restoration remain compositor trial items.
- Stage C media, EQ, Wi-Fi, Bluetooth, notifications and Stage D secure lock are still placeholders or future work.

The documented Quickshell 0.3.2 API shape was checked against official references in `ARCHITECTURE.md`; execution compatibility on the target system has not been established. Static and Node state-machine checks are recorded in the Stage B1 completion report. No desktop deployment or system configuration change is part of this branch.
