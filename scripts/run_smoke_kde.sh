#!/usr/bin/env bash
set -euo pipefail

case "${XDG_CURRENT_DESKTOP:-}" in
  *KDE*|*Plasma*) ;;
  *) echo "Refusing smoke test: this is not a KDE/Plasma desktop." >&2; exit 2 ;;
esac

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  echo "Refusing smoke test: Hyprland environment detected." >&2
  exit 2
fi

if ! command -v qs >/dev/null 2>&1; then
  echo "Quickshell (qs) is unavailable." >&2
  exit 3
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Opening one ordinary Synn smoke window. Close with Ctrl+C here." >&2
exec qs -p "$repo_dir/smoke/Smoke.qml"
