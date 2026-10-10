#!/usr/bin/env python3
"""Read-only Stage B0 architectural checks; no QML runtime required."""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SHELL = ROOT / "shell"
QML = sorted(SHELL.rglob("*.qml"))
failures = []


def check(condition: bool, message: str) -> None:
    if not condition:
        failures.append(message)


check(len(QML) == 5, f"expected five Stage B0 QML files, found {len(QML)}")
check((SHELL / "Shell.qml").exists(), "Shell.qml missing")
check(len(list(SHELL.rglob("Shell.qml"))) == 1, "multiple Shell.qml entrypoints")
check(not (ROOT / "shell.qml").exists(), "unexpected second entrypoint")

sources = {p.relative_to(ROOT).as_posix(): p.read_text() for p in QML}
all_qml = "\n".join(sources.values())
entry = sources.get("shell/Shell.qml", "")
bar = sources.get("shell/ui/bar/StatusBar.qml", "")
mode = sources.get("shell/core/ModeController.qml", "")
registry = sources.get("shell/core/ApplicationRegistry.qml", "")

check(len(re.findall(r"\bShellRoot\s*\{", all_qml)) == 1, "must have one ShellRoot")
check(len(re.findall(r"\bPanelWindow\s*\{", all_qml)) == 1, "must have one PanelWindow")
check(len(re.findall(r"\bStatusBar\s*\{", entry)) == 1, "must instantiate one status bar")
check(bool(re.search(r"anchors\s*\{[^}]*top:\s*true", bar, re.S)), "bar must anchor at top")
check(not re.search(r"\bbottom:\s*true", bar), "bar must not anchor at bottom")
check("Sanctuary" in mode and "Workshop" in mode, "two locked modes missing")
check("autoCloseApplications: false" in mode, "auto-close must remain off")
check("automaticTerminationAllowed: false" in registry, "registry must forbid automatic termination")
check(all(category in registry for category in ("Pinned", "Protected", "Mode-Owned", "Shared", "External")), "registry categories incomplete")

forbidden_code = re.compile(
    r"\b(Arena|Gaming|Super\+G|Process|execDetached|systemctl|Docker|WlSessionLock|PamContext|kill\s*\(|terminate\s*\()\b",
    re.I,
)
for path, content in sources.items():
    for match in forbidden_code.finditer(content):
        failures.append(f"forbidden Stage B0 code in {path}: {match.group()}")

check(not any("dock" in p.name.lower() or "taskbar" in p.name.lower() for p in QML), "dock/taskbar QML present")
check(not any(p.is_symlink() for p in ROOT.rglob("*")), "repository contains a symlink")
check(not (ROOT / "third_party").exists(), "third-party source must not be vendored in Stage B0")
check((ROOT / "docs/LOCKED_SPEC.md").exists(), "locked specification record missing")

if failures:
    for failure in failures:
        print(f"FAIL: {failure}")
    sys.exit(1)

print(f"PASS: {len(QML)} QML files; one root/bar; two modes; protected registry; no forbidden source surfaces")
