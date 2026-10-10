import QtQuick
import QtQuick.Layouts
import "../shell/core"

FocusScope {
    id: scene
    focus: true
    property string lastAction: "Ready"
    property string activeOverlay: ""

    NocturneTokens { id: tokens }
    MotionTokens { id: motion }
    ModeController { id: modes }
    MockCompositor {
        id: mock
        onWindowsChanged: overview.refresh(mock)
    }
    LauncherController {
        id: launcher
        applicationEntries: mock.applications
        externalExecutionAllowed: false
        onActivated: desktopId => scene.lastAction = "Mock activation: " + desktopId
    }
    OverviewController { id: overview }

    function openLauncher() {
        overview.close();
        activeOverlay = "launcher";
        launcher.open();
    }
    function openOverview() {
        launcher.close();
        activeOverlay = "overview";
        overview.open(mock);
    }
    function reverseMotion() {
        if (activeOverlay === "launcher") {
            launcher.phase === "Opening" || launcher.phase === "Open" ? launcher.close() : launcher.open();
        } else if (activeOverlay === "overview") {
            overview.phase === "Opening" || overview.phase === "Open" ? overview.close() : overview.open(mock);
        } else openLauncher();
    }
    function switchMode(mode) {
        modes.requestMode(mode);
        lastAction = "Mock presentation: " + mode;
    }

    Keys.onPressed: event => {
        if (!(event.modifiers & Qt.ControlModifier)) return;
        if (event.key === Qt.Key_L) { openLauncher(); event.accepted = true; }
        else if (event.key === Qt.Key_O) { openOverview(); event.accepted = true; }
        else if (event.key === Qt.Key_1) { switchMode("Sanctuary"); event.accepted = true; }
        else if (event.key === Qt.Key_2) { switchMode("Workshop"); event.accepted = true; }
        else if (event.key === Qt.Key_R) { reverseMotion(); event.accepted = true; }
    }

    Timer {
        id: launcherTimer
        interval: Math.max(1, motion.overlayMs + 10)
        onTriggered: launcher.animationFinished()
    }
    Timer {
        id: overviewTimer
        interval: Math.max(1, motion.overlayMs + 10)
        onTriggered: overview.animationFinished()
    }
    Connections {
        target: launcher
        function onPhaseChanged() {
            if (launcher.phase === "Opening" || launcher.phase === "Closing") launcherTimer.restart();
            else launcherTimer.stop();
            if (launcher.phase === "Closed" && !overview.visible) scene.forceActiveFocus();
        }
    }
    Connections {
        target: overview
        function onPhaseChanged() {
            if (overview.phase === "Opening" || overview.phase === "Closing") overviewTimer.restart();
            else overviewTimer.stop();
            if (overview.phase === "Closed" && !launcher.visible) scene.forceActiveFocus();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: modes.currentMode === "Sanctuary" ? tokens.carbon : "#171c20"
        Behavior on color { ColorAnimation { duration: motion.modeMs } }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            Text { text: "Synn"; color: tokens.pearl; font.pixelSize: 24; font.weight: Font.DemiBold }
            Text { text: "INTERACTIVE PREVIEW · MOCK DATA"; color: tokens.teal; font.pixelSize: 11; font.letterSpacing: 1.5 }
            Item { Layout.fillWidth: true }
            Text { text: "No compositor access"; color: tokens.steel; font.pixelSize: 11 }
        }

        RowLayout {
            spacing: 8
            PreviewButton { label: "Sanctuary"; accent: tokens.teal; onClicked: scene.switchMode("Sanctuary") }
            PreviewButton { label: "Workshop"; accent: tokens.amber; onClicked: scene.switchMode("Workshop") }
            PreviewButton { label: "Launcher"; onClicked: scene.openLauncher() }
            PreviewButton { label: "Overview"; onClicked: scene.openOverview() }
            PreviewButton { label: "Reverse motion"; onClicked: scene.reverseMotion() }
        }

        RowLayout {
            spacing: 8
            PreviewButton { label: motion.reducedMotion ? "Reduced motion ON" : "Reduced motion OFF"; onClicked: motion.reducedMotion = !motion.reducedMotion }
            PreviewButton { label: motion.lowPower ? "Low power ON" : "Low power OFF"; accent: tokens.amber; onClicked: motion.lowPower = !motion.lowPower }
            PreviewButton { label: "Add mock window"; onClicked: mock.launchMock("files", "New mock window") }
            PreviewButton { label: "Remove focused mock"; accent: tokens.coral; onClicked: mock.removeWindow(mock.activeAddress()) }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: tokens.cornerRadius
            color: tokens.graphite
            border.color: modes.currentMode === "Sanctuary" ? tokens.teal : tokens.amber
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 26
                spacing: 12
                Text { text: modes.currentMode; color: modes.currentMode === "Sanctuary" ? tokens.teal : tokens.amber; font.pixelSize: 30 }
                Text { text: modes.currentMode === "Sanctuary" ? "Calm, wallpaper-first presentation" : "Focused development presentation"; color: tokens.pearl; font.pixelSize: 16 }
                Text { text: "All windows below are synthetic. No real app or process is launched, moved, or closed."; color: tokens.steel; font.pixelSize: 13 }
                Repeater {
                    model: mock.windows
                    delegate: Text {
                        required property var modelData
                        text: (modelData.address === mock.focusedAddress ? "●  " : "○  ") + modelData.title + "  ·  Workspace " + modelData.workspaceName
                        color: modelData.address === mock.focusedAddress ? tokens.pearl : tokens.steel
                        font.pixelSize: 14
                    }
                }
                Item { Layout.fillHeight: true }
                Text { text: "Last action: " + scene.lastAction; color: tokens.pearl; font.pixelSize: 12 }
                Text { text: "Window shortcuts: Ctrl+L launcher · Ctrl+O Overview · Ctrl+1/2 modes · Ctrl+R reverse"; color: tokens.steel; font.pixelSize: 11 }
            }
        }
    }

    Rectangle {
        id: launcherLayer
        anchors.fill: parent
        z: scene.activeOverlay === "launcher" ? 20 : 10
        visible: launcher.visible
        color: "#e911171b"
        opacity: launcher.phase === "Closing" ? 0 : 1
        scale: launcher.phase === "Closing" ? motion.hiddenScale : 1
        Behavior on opacity { NumberAnimation { duration: motion.overlayMs; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: motion.overlayMs; easing.type: Easing.OutCubic } }
        onVisibleChanged: {
            if (visible) { search.text = ""; focusLauncher.start(); }
        }

        Timer { id: focusLauncher; interval: 1; onTriggered: search.forceActiveFocus() }
        ColumnLayout {
            width: Math.min(650, parent.width - 64)
            height: Math.min(530, parent.height - 80)
            anchors.centerIn: parent
            spacing: 12
            Text { text: "Synn Launcher · mock entries"; color: tokens.pearl; font.pixelSize: 24 }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                radius: 9
                color: tokens.graphite
                border.color: tokens.teal
                TextInput {
                    id: search
                    anchors.fill: parent
                    anchors.margins: 14
                    color: tokens.pearl
                    font.pixelSize: 18
                    verticalAlignment: TextInput.AlignVCenter
                    onTextChanged: launcher.search(text)
                    Keys.onDownPressed: launcher.move(1)
                    Keys.onUpPressed: launcher.move(-1)
                    Keys.onReturnPressed: launcher.activateSelected(mock)
                    Keys.onEnterPressed: launcher.activateSelected(mock)
                    Keys.onEscapePressed: launcher.close()
                    Keys.onPressed: event => {
                        if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_R) {
                            scene.reverseMotion();
                            event.accepted = true;
                        }
                    }
                }
                Text { anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; visible: search.text.length === 0; text: "Type to filter mock applications"; color: tokens.steel; font.pixelSize: 18 }
            }
            Text { text: "↑ ↓ select · Enter focus or create mock · Esc close"; color: tokens.steel; font.pixelSize: 12 }
            Repeater {
                model: launcher.results
                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    Layout.fillWidth: true
                    Layout.preferredHeight: 46
                    radius: 8
                    color: index === launcher.selectedIndex ? tokens.graphite : tokens.carbon
                    Text { anchors.left: parent.left; anchors.leftMargin: 14; anchors.verticalCenter: parent.verticalCenter; text: modelData.name + " · " + modelData.genericName; color: tokens.pearl; font.pixelSize: 14 }
                    MouseArea { anchors.fill: parent; onClicked: { launcher.selectedIndex = index; launcher.activateSelected(mock); } }
                }
            }
            Text { visible: launcher.results.length === 0; text: "No mock entry matches"; color: tokens.steel; font.pixelSize: 14 }
            Item { Layout.fillHeight: true }
            RowLayout {
                PreviewButton { label: "Close"; onClicked: launcher.close() }
                PreviewButton { label: "Reverse motion"; onClicked: scene.reverseMotion() }
            }
        }
    }

    FocusScope {
        id: overviewLayer
        anchors.fill: parent
        z: scene.activeOverlay === "overview" ? 20 : 10
        visible: overview.visible
        focus: true
        opacity: overview.phase === "Closing" ? 0 : 1
        scale: overview.phase === "Closing" ? motion.hiddenScale : 1
        Behavior on opacity { NumberAnimation { duration: motion.overlayMs; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: motion.overlayMs; easing.type: Easing.OutCubic } }
        onVisibleChanged: {
            if (visible) focusOverview.start();
        }
        Keys.onPressed: event => {
            if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_R) {
                scene.reverseMotion();
                event.accepted = true;
            }
        }
        Keys.onLeftPressed: overview.move(-1)
        Keys.onUpPressed: overview.move(-1)
        Keys.onRightPressed: overview.move(1)
        Keys.onDownPressed: overview.move(1)
        Keys.onReturnPressed: overview.select(overview.selectedIndex, mock)
        Keys.onEnterPressed: overview.select(overview.selectedIndex, mock)
        Keys.onEscapePressed: overview.close()
        Timer { id: focusOverview; interval: 1; onTriggered: overviewLayer.forceActiveFocus() }

        Rectangle { anchors.fill: parent; color: "#eb11171b" }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 36
            spacing: 16
            Text { text: "Overview · mock windows"; color: tokens.pearl; font.pixelSize: 26 }
            Text { text: "← ↑ → ↓ select · Enter focus mock · Esc close"; color: tokens.steel; font.pixelSize: 12 }
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: Math.max(1, Math.floor(width / 300))
                rowSpacing: 12
                columnSpacing: 12
                Repeater {
                    model: overview.windows
                    delegate: Rectangle {
                        required property var modelData
                        required property int index
                        property bool entered: false
                        Layout.fillWidth: true
                        Layout.preferredHeight: 186
                        radius: 10
                        color: tokens.graphite
                        border.color: index === overview.selectedIndex ? tokens.teal : tokens.steel
                        border.width: index === overview.selectedIndex ? 2 : 1
                        opacity: entered ? 1 : 0
                        scale: entered ? 1 : motion.hiddenScale
                        Behavior on opacity { NumberAnimation { duration: motion.overlayMs } }
                        Behavior on scale { NumberAnimation { duration: motion.overlayMs } }
                        Component.onCompleted: entered = true
                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 10
                            Text { text: "MOCK PREVIEW"; color: tokens.teal; font.pixelSize: 11; font.letterSpacing: 2 }
                            Rectangle { width: parent.width; height: 90; radius: 7; color: tokens.carbon; Text { anchors.centerIn: parent; text: "No screenshot captured"; color: tokens.steel; font.pixelSize: 12 } }
                            Text { text: modelData.title; color: tokens.pearl; font.pixelSize: 13 }
                            Text { text: modelData.monitorName + " · Workspace " + modelData.workspaceName; color: tokens.steel; font.pixelSize: 10 }
                        }
                        MouseArea { anchors.fill: parent; onClicked: overview.select(index, mock) }
                    }
                }
            }
            Text { visible: overview.windows.length === 0; text: "No mock windows"; color: tokens.steel; font.pixelSize: 16 }
            RowLayout {
                PreviewButton { label: "Close"; onClicked: overview.close() }
                PreviewButton { label: "Reverse motion"; onClicked: scene.reverseMotion() }
            }
        }
    }
}
