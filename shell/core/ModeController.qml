import QtQuick
import "../logic/InteractionRules.js" as Rules

QtObject {
    id: controller

    readonly property string sanctuary: "Sanctuary"
    readonly property string workshop: "Workshop"
    readonly property bool autoCloseApplications: false
    property string currentMode: sanctuary
    readonly property var presentationProfile: currentMode === sanctuary ?
        ({ density: "calm", emphasis: "wallpaper", accent: "teal" }) :
        ({ density: "focused", emphasis: "development", accent: "amber" })

    signal transitionAccepted(string previousMode, string nextMode)
    signal transitionRejected(string requestedMode)

    function requestMode(nextMode) {
        const transition = Rules.modeTransition(currentMode, nextMode);
        if (!transition.accepted) {
            transitionRejected(nextMode);
            return false;
        }
        if (!transition.changed)
            return true;

        const previousMode = currentMode;
        currentMode = transition.nextMode;
        transitionAccepted(previousMode, nextMode);
        return true;
    }
}
