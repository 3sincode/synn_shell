import QtQuick
import Quickshell
import "core"
import "ui/bar"

ShellRoot {
    id: root

    // Stage B0 has one scene owner and no desktop/session side effects.
    NocturneTokens { id: tokens }
    ModeController { id: modes }
    ApplicationRegistry { id: applications }

    StatusBar {
        tokens: tokens
        modeController: modes
    }
}
