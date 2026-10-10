import QtQuick
import "../logic/InteractionRules.js" as Rules

QtObject {
    id: registry

    readonly property var categories: ["Pinned", "Protected", "Mode-Owned", "Shared", "External"]
    readonly property bool automaticTerminationAllowed: false
    property var entries: ({})

    signal entryChanged(string applicationId)

    function hasCategory(category) {
        return categories.indexOf(category) !== -1;
    }

    function registerApplication(applicationId, category, kind) {
        if (typeof applicationId !== "string" || applicationId.length === 0 || !hasCategory(category))
            return false;

        const nextEntries = Object.assign({}, entries);
        const normalizedKind = typeof kind === "string" ? kind.toLowerCase() : "application";
        nextEntries[applicationId] = {
            category: Rules.protectedCategory(category, normalizedKind) ? "Protected" : category,
            kind: normalizedKind
        };
        entries = nextEntries;
        entryChanged(applicationId);
        return true;
    }

    function categoryFor(applicationId) {
        return entries[applicationId]?.category ?? "External";
    }

    function isProtected(applicationId) {
        const item = entries[applicationId];
        return !!item && Rules.protectedCategory(item.category, item.kind);
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
