import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../logic/InteractionRules.js" as Rules

Scope {
    id: adapter
    required property QtObject motion
    readonly property bool available: !!Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")
    property var tapState: Rules.newTap()
    signal launcherTap()
    signal modeShortcut(string mode)
    signal overviewShortcut()
    signal windowsChanged()

    function markComboUsed() { tapState = Rules.tapCombo(tapState); }
    function finishSuperTap() {
        const active = Hyprland.activeToplevel;
        const fullscreen = !!(active && active.lastIpcObject && active.lastIpcObject.fullscreen);
        const result = Rules.tapRelease(tapState, Date.now(), available && !fullscreen, motion.maxTapMs);
        tapState = result.state;
        if (result.fire) launcherTap();
    }

    function windowList() {
        if (!available) return [];
        return Hyprland.toplevels.values.filter(function (item) {
            return item && Rules.safeWindowId(item.address);
        }).map(function (item) {
            const ipc = item.lastIpcObject || {};
            const pos = ipc.at || [];
            const size = ipc.size || [];
            return {
                address: item.address,
                title: item.title || "Untitled window",
                appId: ipc.class || "",
                workspaceId: item.workspace ? item.workspace.id : ((ipc.workspace && ipc.workspace.id != null ? ipc.workspace.id : 0)),
                workspaceName: item.workspace ? item.workspace.name : ((ipc.workspace && ipc.workspace.name != null ? ipc.workspace.name : "Unknown")),
                monitorName: item.monitor ? item.monitor.name : "Unknown monitor",
                captureHandle: item.wayland || null,
                layout: { address: item.address, workspaceId: item.workspace ? item.workspace.id : 0,
                    x: pos[0], y: pos[1], width: size[0], height: size[1], floating: !!ipc.floating }
            };
        });
    }

    function focusWindow(address) {
        if (!available || !Hyprland.usingLua || !Rules.safeWindowId(address)) return false;
        if (!windowList().some(function (item) { return item.address === address; })) return false;
        Hyprland.dispatch("hl.dsp.focus({ window = 'address:" + address + "' })");
        return true; // Dispatch acceptance is not confirmation; runtime must verify focus.
    }

    function activeAddress() { return available && Hyprland.activeToplevel ? Hyprland.activeToplevel.address : ""; }

    function focusApplication(entry) {
        if (!available || !entry) return false;
        const expected = String(entry.startupClass || entry.id || "").replace(/\.desktop$/i, "").toLowerCase();
        const match = windowList().find(function (item) { return item.appId.toLowerCase() === expected; });
        return match ? focusWindow(match.address) : false;
    }

    // Shortcut declarations register with Hyprland; this repository installs no binds.
    GlobalShortcut {
        appid: "synn-shell"
        name: "super-tap"
        description: "Synn launcher"
        onPressed: adapter.tapState = Rules.tapPress(adapter.tapState, Date.now())
        onReleased: adapter.finishSuperTap()
    }
    GlobalShortcut {
        appid: "synn-shell"
        name: "sanctuary"
        description: "Synn Sanctuary"
        onPressed: { adapter.markComboUsed(); adapter.modeShortcut("Sanctuary"); }
    }
    GlobalShortcut {
        appid: "synn-shell"
        name: "workshop"
        description: "Synn Workshop"
        onPressed: { adapter.markComboUsed(); adapter.modeShortcut("Workshop"); }
    }
    GlobalShortcut {
        appid: "synn-shell"
        name: "overview"
        description: "Synn Overview"
        onPressed: { adapter.markComboUsed(); adapter.overviewShortcut(); }
    }

    Timer {
        id: windowRefresh
        interval: 80
        repeat: false
        onTriggered: adapter.windowsChanged()
    }
    Connections {
        target: Hyprland
        function onRawEvent(event) { if (adapter.available) windowRefresh.restart(); }
    }
}
