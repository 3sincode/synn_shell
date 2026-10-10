import QtQuick
import "../logic/InteractionRules.js" as Rules

QtObject {
    id: overview
    property string phase: "Closed"
    property var windows: []
    property int selectedIndex: -1
    property bool restorePreviousFocus: true
    property string lastError: ""
    readonly property bool visible: phase !== "Closed"
    signal selectionFailed(string reason)

    function open(adapter) {
        restorePreviousFocus = true;
        lastError = "";
        windows = adapter ? adapter.windowList() : [];
        selectedIndex = windows.length ? 0 : -1;
        phase = Rules.overlayStep(phase, "open");
    }
    function close() { phase = Rules.overlayStep(phase, "close"); }
    function animationFinished() {
        phase = Rules.overlayStep(phase, phase === "Opening" ? "opened" : "closed");
        if (phase === "Closed") { windows = []; selectedIndex = -1; }
    }
    function refresh(adapter) {
        if (!visible) return;
        const selectedAddress = windows[selectedIndex]?.address;
        windows = adapter ? adapter.windowList() : [];
        selectedIndex = windows.findIndex(function (w) { return w.address === selectedAddress; });
        if (selectedIndex < 0) selectedIndex = windows.length ? 0 : -1;
    }
    function move(delta) { selectedIndex = Rules.moveSelection(selectedIndex, delta, windows.length); }
    function select(index, adapter) {
        const item = windows[index];
        if (!item || !Rules.safeWindowId(item.address) || !adapter || !adapter.focusWindow(item.address)) {
            lastError = "Window vanished or compositor focus failed";
            selectionFailed(lastError);
            refresh(adapter);
            return false;
        }
        restorePreviousFocus = false;
        close();
        return true;
    }
}
