import QtQuick
import Quickshell

// An ordinary desktop window with no compositor integration.
ShellRoot {
    FloatingWindow {
        id: smoke
        visible: true
        title: "Synn smoke test"
        implicitWidth: 420
        implicitHeight: 180
        color: "#11171b"

        Text {
            anchors.centerIn: parent
            text: "Synn · Quickshell window loaded"
            color: "#edf2ef"
            font.pixelSize: 18
        }
    }
}
