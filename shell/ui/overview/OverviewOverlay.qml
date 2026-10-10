import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

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
        if (visible) { focusAttempts = 0; focusRetry.restart(); }
        else focusRetry.stop();
    }

    FocusScope {
        id: keyScope
        anchors.fill: parent
        focus: true
        Keys.onLeftPressed: panel.controller.move(-1)
        Keys.onUpPressed: panel.controller.move(-1)
        Keys.onRightPressed: panel.controller.move(1)
        Keys.onDownPressed: panel.controller.move(1)
        Keys.onReturnPressed: panel.controller.select(panel.controller.selectedIndex, panel.adapter)
        Keys.onEnterPressed: panel.controller.select(panel.controller.selectedIndex, panel.adapter)
        Keys.onEscapePressed: panel.controller.close()
    }

    Timer {
        id: focusRetry
        interval: 70
        repeat: true
        onTriggered: {
            if (!panel.visible || keyScope.activeFocus) { stop(); return; }
            keyScope.forceActiveFocus();
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
        color: "#d911171b"
        opacity: panel.controller.phase === "Closing" ? 0 : 1
        Behavior on opacity { NumberAnimation { duration: panel.motion.overlayMs } }
        MouseArea { anchors.fill: parent; onClicked: panel.controller.close() }
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 32
        spacing: tokens.spaceMedium
        opacity: panel.controller.phase === "Closing" ? 0 : 1
        scale: panel.controller.phase === "Closing" ? motion.hiddenScale : 1
        Behavior on opacity { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Overview"; color: tokens.pearl; font.pixelSize: 28; font.weight: Font.DemiBold }
            Item { Layout.fillWidth: true }
            Text { text: "Window snapshots · live previews unavailable until verified"; color: tokens.steel; font.pixelSize: 12 }
        }

        Text {
            visible: panel.controller.windows.length === 0
            text: panel.adapter.available ? "No open windows" : "Hyprland windows unavailable in this session"
            color: tokens.steel
            font.pixelSize: 16
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
            contentHeight: grid.implicitHeight
            clip: true
            GridLayout {
                id: grid
                width: parent.width
                columns: Math.max(1, Math.floor(width / 290))
                rowSpacing: 14
                columnSpacing: 14
                Repeater {
                    model: panel.controller.windows
                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        property bool entered: false
                        Layout.fillWidth: true
                        Layout.preferredHeight: 210
                        radius: tokens.cornerRadius
                        color: tokens.graphite
                        opacity: entered ? 1 : 0
                        scale: entered ? 1 : panel.motion.hiddenScale
                        Behavior on opacity { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }
                        Behavior on scale { NumberAnimation { duration: panel.motion.overlayMs; easing.type: Easing.OutCubic } }
                        Component.onCompleted: entered = true
                        border.width: index === panel.controller.selectedIndex ? 2 : 1
                        border.color: index === panel.controller.selectedIndex ? tokens.teal : tokens.steel

                        ScreencopyView {
                            id: preview
                            x: 8; y: 8; width: parent.width - 16; height: 155
                            captureSource: modelData.captureHandle
                            live: false
                            visible: hasContent && panel.controller.visible
                            Component.onCompleted: { if (captureSource) captureFrame(); }
                        }
                        Text {
                            anchors.centerIn: preview
                            visible: !preview.hasContent
                            text: "Preview unavailable"
                            color: tokens.steel
                            font.pixelSize: 12
                        }
                        Text {
                            x: 12; y: 168; width: parent.width - 24
                            text: modelData.title
                            color: tokens.pearl
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }
                        Text {
                            x: 12; y: 188; width: parent.width - 24
                            text: modelData.monitorName + " · Workspace " + modelData.workspaceName
                            color: tokens.steel
                            font.pixelSize: 10
                            elide: Text.ElideRight
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: panel.controller.select(index, panel.adapter)
                        }
                    }
                }
            }
        }
        Text { text: "← ↑ → ↓ Select     Enter Focus     Esc Close"; color: tokens.steel; font.pixelSize: 11 }
    }
}
