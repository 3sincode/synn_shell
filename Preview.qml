import Quickshell
import "preview"

// Separate preview entrypoint; the production desktop still starts at shell/Shell.qml.
ShellRoot {
    PreviewWindow {}
}
