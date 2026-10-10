import QtQuick

QtObject {
    id: motion
    property bool reducedMotion: false
    property bool lowPower: false
    readonly property int overlayMs: reducedMotion ? 0 : (lowPower ? 130 : 260)
    readonly property int modeMs: reducedMotion ? 0 : (lowPower ? 100 : 320)
    readonly property real hiddenScale: reducedMotion ? 1.0 : 0.965
    readonly property int maxTapMs: 320
}
