import QtQuick

QtObject {
    id: mock
    readonly property bool available: true
    property string focusedAddress: "0x1001"
    property int nextWindowId: 4100
    property var windows: [
        { address: "0x1001", title: "Music library · mock", appId: "music", workspaceName: "1", monitorName: "Mock monitor A" },
        { address: "0x1002", title: "Code workspace · mock", appId: "code", workspaceName: "2", monitorName: "Mock monitor A" },
        { address: "0x1003", title: "Notes · mock", appId: "notes", workspaceName: "2", monitorName: "Mock monitor B" }
    ]
    property var applications: [
        { id: "music.desktop", name: "Music", genericName: "Library", keywords: ["songs", "audio"], startupClass: "music", noDisplay: false, runInTerminal: false },
        { id: "code.desktop", name: "Code", genericName: "Editor", keywords: ["development", "workshop"], startupClass: "code", noDisplay: false, runInTerminal: false },
        { id: "notes.desktop", name: "Notes", genericName: "Writing", keywords: ["text", "sanctuary"], startupClass: "notes", noDisplay: false, runInTerminal: false },
        { id: "files.desktop", name: "Files", genericName: "File manager", keywords: ["folders"], startupClass: "files", noDisplay: false, runInTerminal: false }
    ]

    function windowList() { return windows.slice(); }
    function activeAddress() { return focusedAddress; }
    function focusWindow(address) {
        if (!windows.some(function (window) { return window.address === address; })) return false;
        focusedAddress = address;
        return true;
    }
    function focusApplication(entry) {
        const match = windows.find(function (window) { return window.appId === entry.startupClass; });
        return match ? focusWindow(match.address) : false;
    }
    function launchApplication(entry) {
        if (!applications.some(function (known) { return known.id === entry.id; })) return false;
        launchMock(entry.startupClass, entry.name + " · mock");
        return true;
    }
    function launchMock(appId, title) {
        const address = "0x" + (++nextWindowId).toString(16);
        windows = windows.concat([{ address: address, title: title, appId: appId,
            workspaceName: "3", monitorName: "Mock monitor A" }]);
        focusedAddress = address;
    }
    function removeWindow(address) {
        windows = windows.filter(function (window) { return window.address !== address; });
        if (focusedAddress === address) focusedAddress = windows.length ? windows[0].address : "";
    }
}
