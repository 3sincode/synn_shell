import QtQuick

QtObject {
    id: controller

    readonly property string sanctuary: "Sanctuary"
    readonly property string workshop: "Workshop"
    readonly property bool autoCloseApplications: false
    property string currentMode: sanctuary

    signal transitionAccepted(string previousMode, string nextMode)
    signal transitionRejected(string requestedMode)

    function requestMode(nextMode) {
        if (nextMode !== sanctuary && nextMode !== workshop) {
            transitionRejected(nextMode);
            return false;
        }
        if (nextMode === currentMode)
            return true;

        const previousMode = currentMode;
        currentMode = nextMode;
        transitionAccepted(previousMode, nextMode);
        return true;
    }
}
