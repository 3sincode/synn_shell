#!/usr/bin/env python3
"""Read-only Stage B1 architectural invariants; no desktop runtime needed."""

from pathlib import Path
import re
import sys

root = Path(__file__).resolve().parents[1]
shell = root / "shell"
qml_files = sorted(shell.rglob("*.qml"))
sources = {p.relative_to(root).as_posix(): p.read_text() for p in qml_files}
all_qml = "\n".join(sources.values())
failures = []


def check(condition: bool, message: str) -> None:
    if not condition:
        failures.append(message)


check(len(re.findall(r"\bShellRoot\s*\{", all_qml)) == 1, "one ShellRoot required")
check(len(re.findall(r"\bStatusBar\s*\{", sources.get("shell/Shell.qml", ""))) == 1, "one shared bar required")
check(len(list(shell.rglob("Shell.qml"))) == 1, "one Shell.qml required")
check(not (root / "shell.qml").exists(), "second shell entrypoint found")

mode = sources.get("shell/core/ModeController.qml", "")
check(re.findall(r'readonly property string \w+: "([^"]+)"', mode) == ["Sanctuary", "Workshop"],
      "exactly two mode constants required")
check("autoCloseApplications: false" in mode, "mode auto-close must remain false")
registry = sources.get("shell/core/ApplicationRegistry.qml", "")
check("automaticTerminationAllowed: false" in registry, "automatic termination must remain false")
for category in ("Pinned", "Protected", "Mode-Owned", "Shared", "External"):
    check(category in registry, f"registry missing {category}")

bar = sources.get("shell/ui/bar/StatusBar.qml", "")
check(bool(re.search(r"anchors\s*\{[^}]*top:\s*true", bar, re.S)), "bar must be top-anchored")
check("bottom: true" not in bar, "bar must not be bottom-anchored")
check('text: "Synn"' in bar, "visible brand must be Synn")
check("DesktopEntries.applications.values" in all_qml, "desktop entry search missing")
check("ScreencopyView" in all_qml and "Preview unavailable" in all_qml,
      "overview must have preview and explicit fallback")
lua = root / "config/hyprland/synn-b1-review.lua"
check(lua.exists(), "Hyprland Lua review module missing")
check(not (root / "config/hyprland/synn-b1-review.conf").exists(), "obsolete Hyprland config present")
if lua.exists():
    lua_source = lua.read_text()
    check('hl.bind("SUPER + I", hl.dsp.global("synn-shell:sanctuary")' in lua_source,
          "Sanctuary Lua bind missing")
    check('hl.bind("SUPER + D", hl.dsp.global("synn-shell:workshop")' in lua_source,
          "Workshop Lua bind missing")
    check('hl.bind("SUPER + Tab", hl.dsp.global("synn-shell:overview")' in lua_source,
          "Overview Lua bind missing")
    check(not re.search(r'^\s*hl\.bind\("Super_L"', lua_source, re.M),
          "Super-only bind must remain disabled")

smoke = root / "smoke/Smoke.qml"
check(smoke.exists(), "isolated smoke QML missing")
if smoke.exists():
    smoke_source = smoke.read_text()
    check("FloatingWindow" in smoke_source and not re.search(
        r"\b(PanelWindow|GlobalShortcut|WlSessionLock|HyprlandAdapter)\b", smoke_source),
        "smoke QML must use only an ordinary window")
trial = root / "config/hyprland/trial/hyprland.lua"
check(trial.exists(), "isolated Hyprland trial config missing")
if trial.exists():
    trial_source = trial.read_text()
    check("synn-b1-review" not in trial_source and "hl.dsp.exit()" in trial_source,
          "trial config must not load Synn shortcuts and needs a local exit")
check("hl.dsp.focus({ window = 'address:" in sources.get("shell/adapters/HyprlandAdapter.qml", ""),
      "Hyprland 0.56 Lua focus dispatch missing")

for path, content in sources.items():
    for pattern in (r"\bArena\b", r"\bGaming\b", r"Super\+G", r"\bexecDetached\b",
                    r"\bsystemctl\b", r"\bpkill\b", r"\bterminate\s*\(", r"\bkill\s*\("):
        if re.search(pattern, content, re.I):
            failures.append(f"forbidden source in {path}: {pattern}")
    for imported in re.findall(r'^import\s+"([^"]+)"', content, re.M):
        check(imported.startswith("./") or imported.startswith("../") or imported in
              ("core", "adapters", "ui/bar", "ui/launcher", "ui/overview"),
              f"unexpected local import in {path}: {imported}")

check(not any("dock" in p.name.lower() or "taskbar" in p.name.lower() for p in qml_files),
      "dock/taskbar QML exists")
check(not (root / "third_party").exists(), "upstream source must not be vendored")

if failures:
    for failure in failures:
        print("FAIL:", failure)
    sys.exit(1)

print(f"PASS: {len(qml_files)} QML files; one root/bar; two modes; safe launcher/overview boundaries")
