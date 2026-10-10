# Synn desktop shell

An independent Quickshell desktop project. The user-facing name is **Synn**; technical identifiers use `synn-shell`.

## Stage B1 status

Stage B1 is source implementation for review, not a deployed desktop. It has one `Shell.qml`, one shared top status bar, a desktop-entry launcher, a Hyprland window Overview, two presentation modes, motion tokens, and a read-only window layout snapshot contract. Compositor behavior is **NOT RUNTIME TESTED**. Window layout restoration is deliberately gated and reports failure; no window positions are changed by mode transitions.

The shell remains dockless and taskbarless. It contains no bottom-edge reveal, automatic application termination, or service controls. Stage C media/network features and Stage D secure lock are not implemented.

## Repository layout

- `shell/Shell.qml`: single scene owner and interaction wiring.
- `shell/core/`: controllers, registry, visual and motion tokens.
- `shell/adapters/`: Quickshell Hyprland and global shortcut boundary.
- `shell/logic/`: pure interaction rules used by QML and tests.
- `shell/ui/`: shared top bar and transient launcher/Overview panels.
- `config/hyprland/`: review-only keybind candidate; never sourced automatically.
- `docs/`: locked requirements, architecture, status, and trial gates.
- `scripts/`, `tests/`: static invariants and state-machine tests.

## Local checks

```sh
python3 scripts/check_stage_b1.py
node --test tests/interaction.test.mjs
git diff --check
```

Node can be supplied from the Codex bundled runtime if it is absent from `PATH`. This authoring environment has no `qs` or `qmllint`, so QML syntax and runtime integration remain unverified. See [Stage B1 status](docs/STAGE_B1_STATUS.md) and [trial gates](docs/STAGE_B1_GATES.md) before any isolated test. The review keybind fragment must not be installed in the active KDE session.

No third-party source or assets are vendored. A license for original Synn code has not yet been selected.
