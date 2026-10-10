import QtQuick
import Quickshell

FloatingWindow {
    visible: true
    title: "Synn Interactive Preview · mock data"
    implicitWidth: 1060
    implicitHeight: 720
    color: "#11171b"

    PreviewScene { anchors.fill: parent }
}
