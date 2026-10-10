import QtQuick

QtObject {
    readonly property color carbon: "#11171b"
    readonly property color graphite: "#202b30"
    readonly property color steel: "#899ba2"
    readonly property color pearl: "#edf2ef"
    readonly property color teal: "#58b8af"
    readonly property color amber: "#d8a55e"
    readonly property color coral: "#d37e73"

    readonly property int barHeight: 44
    readonly property int cornerRadius: 12
    readonly property int spaceSmall: 8
    readonly property int spaceMedium: 16
    readonly property int motionFastMs: 160
    readonly property int motionStandardMs: 280
    readonly property int motionSlowMs: 440

    // B1 will bind this to an actual user/system preference.
    property bool reducedMotion: false
    property bool lowPower: false
}
