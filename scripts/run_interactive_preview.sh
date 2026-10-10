#!/usr/bin/env bash
set -euo pipefail

case "${XDG_CURRENT_DESKTOP:-}" in
  *KDE*|*Plasma*) ;;
  *) echo "Refusing preview: KDE/Plasma desktop not detected." >&2; exit 2 ;;
esac

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  echo "Refusing preview: Hyprland environment detected." >&2
  exit 2
fi

if ! command -v qs >/dev/null 2>&1; then
  echo "Quickshell (qs) is unavailable." >&2
  exit 3
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Synn Interactive Preview uses mock data. Stop with Ctrl+C in this terminal." >&2
exec env QS_DISABLE_FILE_WATCHER=1 qs -p "$repo_dir/Preview.qml"
