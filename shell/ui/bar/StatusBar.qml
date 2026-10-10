import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: bar

    required property QtObject tokens
    required property QtObject modeController
    required property QtObject launcherController
    required property QtObject overviewController
    required property QtObject motion
    signal openLauncherRequested()
    signal openOverviewRequested()
    signal modeRequested(string mode)

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

            Repeater {
                model: ["Sanctuary", "Workshop"]
                delegate: Text {
                    required property string modelData
                    text: modelData
                    color: bar.modeController.currentMode === modelData ?
                           (modelData === "Sanctuary" ? tokens.teal : tokens.amber) : tokens.steel
                    font.pixelSize: 13
                    font.weight: bar.modeController.currentMode === modelData ? Font.DemiBold : Font.Normal
                    Behavior on color { ColorAnimation { duration: bar.motion.modeMs } }
                    MouseArea { anchors.fill: parent; onClicked: bar.modeRequested(modelData) }
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Apps"
                color: tokens.pearl
                font.pixelSize: 12
                MouseArea { anchors.fill: parent; onClicked: bar.openLauncherRequested() }
            }
            Text {
                text: "Overview"
                color: tokens.pearl
                font.pixelSize: 12
                MouseArea { anchors.fill: parent; onClicked: bar.openOverviewRequested() }
            }
        }
    }
}
