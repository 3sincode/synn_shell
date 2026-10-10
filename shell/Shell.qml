import QtQuick
import Quickshell
import "core"
import "adapters"
import "ui/bar"
import "ui/launcher"
import "ui/overview"

ShellRoot {
    id: root

    NocturneTokens { id: tokens }
    MotionTokens {
        id: motion
        reducedMotion: Quickshell.env("SYNN_REDUCED_MOTION") === "1"
        lowPower: Quickshell.env("SYNN_LOW_POWER") === "1"
    }
    ModeController { id: modes }
    ApplicationRegistry { id: applications }
    WindowLayoutController { id: layouts }
    LauncherController { id: launcher }
    OverviewController { id: overview }
    HyprlandAdapter {
        id: compositor
        motion: motion
        onLauncherTap: root.openLauncher()
        onModeShortcut: mode => root.requestMode(mode)
        onOverviewShortcut: root.openOverview()
        onWindowsChanged: overview.refresh(compositor)
    }

    property string focusBeforeOverlay: ""
    function requestMode(nextMode) {
        if (nextMode === modes.currentMode) return;
        layouts.capture(modes.currentMode, compositor);
        modes.requestMode(nextMode);
        layouts.restore(nextMode, compositor);
        launcher.close();
        overview.close();
    }
    function openLauncher() {
        if (!launcher.visible) focusBeforeOverlay = compositor.activeAddress();
        overview.close();
        launcher.toggle();
    }
    function openOverview() {
        if (!overview.visible) focusBeforeOverlay = compositor.activeAddress();
        launcher.close();
        overview.open(compositor);
    }
    Connections {
        target: launcher
        function onPhaseChanged() {
            if (launcher.phase === "Closed" && launcher.restorePreviousFocus && !overview.visible)
                compositor.focusWindow(root.focusBeforeOverlay);
        }
    }
    Connections {
        target: overview
        function onPhaseChanged() {
            if (overview.phase === "Closed" && overview.restorePreviousFocus && !launcher.visible)
                compositor.focusWindow(root.focusBeforeOverlay);
        }
    }

    StatusBar {
        tokens: tokens
        modeController: modes
        launcherController: launcher
        overviewController: overview
        motion: motion
        onOpenLauncherRequested: root.openLauncher()
        onOpenOverviewRequested: root.openOverview()
        onModeRequested: mode => root.requestMode(mode)
    }
    LauncherOverlay { controller: launcher; adapter: compositor; tokens: tokens; motion: motion }
    OverviewOverlay { controller: overview; adapter: compositor; tokens: tokens; motion: motion }
}
