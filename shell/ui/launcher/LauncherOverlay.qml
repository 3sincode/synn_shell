import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: panel
    required property QtObject controller
    required property QtObject adapter
    required property QtObject tokens
    required property QtObject motion
    property int focusAttempts: 0

    anchors { top: true; left: true; right: true; bottom: true }
    visible: controller.visible
    focusable: true
    color: "transparent"
    exclusiveZone: 0

    onVisibleChanged: {
        if (visible) { search.text = ""; focusAttempts = 0; focusRetry.restart(); }
        else focusRetry.stop();
    }

    Timer {
        id: focusRetry
        interval: 70
        repeat: true
        onTriggered: {
            if (!panel.visible || search.activeFocus) { stop(); return; }
            search.forceActiveFocus();
            panel.focusAttempts++;
            if (panel.focusAttempts >= 5) { stop(); panel.controller.close(); }
        }
    }
    Timer {
        id: phaseTimer
        interval: Math.max(1, panel.motion.overlayMs + 10)
        repeat: false
        onTriggered: panel.controller.animationFinished()
    }
    Connections {
        target: panel.controller
        function onPhaseChanged() {
            if (panel.controller.phase === "Opening") { phaseTimer.restart(); focusRetry.restart(); }
            else if (panel.controller.phase === "Closing") { focusRetry.stop(); phaseTimer.restart(); }
            else phaseTimer.stop();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#a911171b"
        opacity: panel.controller.phase === "Closing" ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: panel.motion.overlayMs } }
        MouseArea { anchors.fill: parent; onClicked: panel.controller.close() }
    }

    Rectangle {
        id: card
        width: Math.min(680, panel.width - 40)
        height: Math.min(540, panel.height - 80)
        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.max(28, (panel.height - height) * 0.24)
        radius: tokens.cornerRadius
        color: tokens.graphite
        border.color: tokens.steel
        border.width: 1
        opacity: panel.controller.phase === "Closing" ? 0 : 1
        scale: panel.controller.phase === "Closing" ? motion.hiddenScale : 1
        Behavior on opacity { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: tokens.spaceMedium
            spacing: tokens.spaceMedium

            RowLayout {
                Layout.fillWidth: true
                Text { text: "Synn"; color: tokens.pearl; font.pixelSize: 20; font.weight: Font.DemiBold }
                Item { Layout.fillWidth: true }
                Text { text: "LAUNCHER"; color: tokens.teal; font.pixelSize: 11; font.letterSpacing: 2 }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 48
                radius: tokens.cornerRadius
                color: tokens.carbon
                border.color: search.activeFocus ? tokens.teal : tokens.steel
                TextInput {
                    id: search
                    anchors.fill: parent
                    anchors.margins: 14
                    color: tokens.pearl
                    selectionColor: tokens.teal
                    font.pixelSize: 17
                    verticalAlignment: TextInput.AlignVCenter
                    onTextChanged: panel.controller.search(text)
                    Keys.onDownPressed: panel.controller.move(1)
                    Keys.onUpPressed: panel.controller.move(-1)
                    Keys.onReturnPressed: panel.controller.activateSelected(panel.adapter)
                    Keys.onEnterPressed: panel.controller.activateSelected(panel.adapter)
                    Keys.onEscapePressed: panel.controller.close()
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    visible: search.text.length === 0
                    text: "Search applications"
                    color: tokens.steel
                    font.pixelSize: 17
                }
            }

            Text {
                text: panel.controller.results.length ? "APPLICATIONS" : "No matching applications"
                color: tokens.steel
                font.pixelSize: 11
                font.letterSpacing: 1.5
            }
            Text {
                visible: panel.controller.lastError.length > 0
                text: panel.controller.lastError
                color: tokens.coral
                font.pixelSize: 12
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: resultColumn.implicitHeight
                clip: true
                Column {
                    id: resultColumn
                    width: parent.width
                    spacing: 3
                    Repeater {
                        model: panel.controller.results
                        delegate: Rectangle {
                            required property var modelData
                            required property int index
                            width: resultColumn.width
                            height: 48
                            radius: 8
                            color: index === panel.controller.selectedIndex ? tokens.carbon : "transparent"
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                Text { text: modelData.name; color: tokens.pearl; font.pixelSize: 14; Layout.fillWidth: true; elide: Text.ElideRight }
                                Text { text: modelData.runInTerminal ? "terminal" : modelData.genericName; color: tokens.steel; font.pixelSize: 11; elide: Text.ElideRight; Layout.maximumWidth: 190 }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    panel.controller.selectedIndex = index;
                                    panel.controller.activateSelected(panel.adapter);
                                }
                            }
                        }
                    }
                }
            }

            Text { text: "↑ ↓ Navigate     Enter Open or focus     Esc Close"; color: tokens.steel; font.pixelSize: 11 }
        }
    }
}
