import QtQuick
import Quickshell
import "../logic/InteractionRules.js" as Rules

QtObject {
    id: launcher
    property string phase: "Closed"
    property string query: ""
    property int selectedIndex: -1
    property var results: []
    property bool restorePreviousFocus: true
    property string lastError: ""
    readonly property bool visible: phase !== "Closed"
    readonly property bool canReceiveKeys: phase === "Open" || phase === "Opening"
    signal activated(string desktopId)
    signal activationFailed(string desktopId, string reason)

    function refresh() {
        results = Rules.matchingApps(DesktopEntries.applications.values, query);
        selectedIndex = results.length ? 0 : -1;
    }

    function open() {
        restorePreviousFocus = true;
        lastError = "";
        query = "";
        refresh();
        phase = Rules.overlayStep(phase, "open");
    }

    function close() { phase = Rules.overlayStep(phase, "close"); }
    function toggle() { visible ? close() : open(); }
    function animationFinished() {
        phase = Rules.overlayStep(phase, phase === "Opening" ? "opened" : "closed");
        if (phase === "Closed") { query = ""; results = []; selectedIndex = -1; }
    }
    function search(text) { query = text; refresh(); }
    function move(delta) { selectedIndex = Rules.moveSelection(selectedIndex, delta, results.length); }

    function activateSelected(adapter) {
        if (selectedIndex < 0 || selectedIndex >= results.length) return false;
        const entry = results[selectedIndex];
        if (!entry || !entry.id) return false;
        if (adapter && adapter.focusApplication(entry)) {
            restorePreviousFocus = false;
            activated(entry.id);
            close();
            return true;
        }
        if (entry.runInTerminal) {
            lastError = "Terminal application launch needs a configured terminal adapter";
            activationFailed(entry.id, lastError);
            return false;
        }
        try { entry.execute(); }
        catch (error) {
            lastError = "Application launch failed";
            activationFailed(entry.id, lastError);
            return false;
        }
        restorePreviousFocus = false;
        activated(entry.id);
        close();
        return true;
    }
}
