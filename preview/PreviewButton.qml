import QtQuick

Rectangle {
    id: button
    property string label: ""
    property color accent: "#58b8af"
    signal clicked()
    implicitWidth: Math.max(88, caption.implicitWidth + 24)
    implicitHeight: 34
    radius: 8
    color: hover.containsMouse ? accent : "#202b30"
    border.color: accent
    border.width: 1

    Text {
        id: caption
        anchors.centerIn: parent
        text: button.label
        color: "#edf2ef"
        font.pixelSize: 12
    }
    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
