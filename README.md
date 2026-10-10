# Synn desktop shell

Independent Quickshell desktop project. This repository has no integration with the personal AI project at `/home/sinn/Projects/Synn` and must not acquire a shared daemon, database, API, IPC, package, runtime dependency, or project-specific configuration with it.

## Stage B0

The current tree is a minimal, **inactive** foundation: one `Shell.qml`, one top status bar, Nocturne Industrial tokens, a two-mode state controller, and an application registry interface. It has no launcher, Overview, real media/network controls, lock screen, hotkeys, installation process, or application lifecycle actions. It does not provide a complete desktop session.

The exact user-facing name is **Synn**. Technical identifiers can use `synn-shell` and `synn`. The locked product requirements are recorded in [`docs/LOCKED_SPEC.md`](docs/LOCKED_SPEC.md), derived from `/home/sinn/Synn Dekstop/punya gweh.md`. Source audit and merge rationale remain at `/home/sinn/Synn Dekstop/research/docs/`.

## Repository layout

- `shell/Shell.qml`: single Quickshell entrypoint and scene owner.
- `shell/core/`: visual tokens, mode state, and registry interface.
- `shell/ui/bar/`: one top bar implementation, without app/task list or bottom surfaces.
- `docs/`: locked requirements, boundaries, and Stage B1 gates.
- `scripts/check_stage_b0.py`: static invariant checks.

Run the static check with `python3 scripts/check_stage_b0.py`. Quickshell/Qt are not installed on this audit host, so QML runtime validation is pending a separate preview environment. The future explicit file-path launch form is `qs -p /home/sinn/Projects/synn-shell/shell/Shell.qml` **only after** the preview environment is approved and prepared; do not add this to startup or run it alongside the active shell without a test plan. [Quickshell documents `--path` for raw QML files](https://quickshell.org/docs/v0.3.2/guide/introduction/).

No license for original Synn code is selected yet. No third-party source or assets are vendored.
