#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$repo_dir"

python3 scripts/check_stage_b1.py
bash -n scripts/run_interactive_preview.sh

if command -v node >/dev/null 2>&1; then
  node --test tests/interaction.test.mjs
else
  echo "NOT TESTED: Node state-machine tests (node unavailable)" >&2
fi

if command -v qmllint >/dev/null 2>&1; then
  qmllint Preview.qml preview/PreviewWindow.qml preview/PreviewScene.qml preview/PreviewButton.qml preview/MockCompositor.qml
else
  echo "NOT TESTED: preview QML lint (qmllint unavailable)" >&2
fi
