import QtQuick

QtObject {
    id: registry

    readonly property var categories: ["Pinned", "Protected", "Mode-Owned", "Shared", "External"]
    readonly property bool automaticTerminationAllowed: false
    property var entries: ({})

    signal entryChanged(string applicationId)

    function hasCategory(category) {
        return categories.indexOf(category) !== -1;
    }

    function registerApplication(applicationId, category) {
        if (typeof applicationId !== "string" || applicationId.length === 0 || !hasCategory(category))
            return false;

        const nextEntries = Object.assign({}, entries);
        nextEntries[applicationId] = { category: category };
        entries = nextEntries;
        entryChanged(applicationId);
        return true;
    }

    function categoryFor(applicationId) {
        return entries[applicationId]?.category ?? "External";
    }

    function isProtected(applicationId) {
        return categoryFor(applicationId) === "Protected";
    }

    function unregisterApplication(applicationId) {
        if (!Object.prototype.hasOwnProperty.call(entries, applicationId))
            return false;

        const nextEntries = Object.assign({}, entries);
        delete nextEntries[applicationId];
        entries = nextEntries;
        entryChanged(applicationId);
        return true;
    }
}
