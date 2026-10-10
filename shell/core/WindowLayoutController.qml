import QtQuick
import "../logic/InteractionRules.js" as Rules

QtObject {
    id: layouts
    property var snapshots: ({ Sanctuary: [], Workshop: [] })
    property string lastError: ""
    readonly property bool automaticWindowMutation: false
    signal snapshotSaved(string mode, int count)
    signal restoreFailed(string mode, string reason)

    function capture(mode, adapter) {
        if (!Rules.validMode(mode) || !adapter || !adapter.available) {
            lastError = "Compositor unavailable";
            return false;
        }
        const valid = adapter.windowList().map(function (item) { return item.layout; })
            .filter(Rules.validSnapshot);
        const next = Object.assign({}, snapshots);
        next[mode] = valid;
        snapshots = next;
        lastError = "";
        snapshotSaved(mode, valid.length);
        return true;
    }

    function restore(mode, adapter) {
        if (!Rules.validMode(mode) || !adapter || !adapter.available) {
            lastError = "Compositor unavailable";
            restoreFailed(mode, lastError);
            return false;
        }
        // Stage B1 does not move/minimize user windows without runtime validation.
        lastError = "Window restore is gated on an isolated Hyprland trial";
        restoreFailed(mode, lastError);
        return false;
    }
}
