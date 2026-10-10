import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar

    required property QtObject tokens
    required property QtObject modeController

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: tokens.barHeight
    color: tokens.carbon
    focusable: false

    Rectangle {
        anchors.fill: parent
        color: tokens.carbon

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: tokens.spaceMedium
            anchors.rightMargin: tokens.spaceMedium
            spacing: tokens.spaceMedium

            Text {
                text: "Synn"
                color: tokens.pearl
                font.pixelSize: 17
                font.weight: Font.DemiBold
            }

            Rectangle {
                width: 1
                height: 18
                color: tokens.graphite
            }

            Text {
                text: bar.modeController.currentMode
                color: bar.modeController.currentMode === "Sanctuary" ? tokens.teal : tokens.amber
                font.pixelSize: 13
                font.weight: Font.Medium
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Stage B0 preview"
                color: tokens.steel
                font.pixelSize: 12
            }
        }
    }
}
