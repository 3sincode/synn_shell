// Pure interaction rules shared by QML and the Node test harness.
function newTap() { return { down: false, used: false, startedAt: 0 }; }

function tapPress(state, now) {
    if (state.down) return state;
    return { down: true, used: false, startedAt: now };
}

function tapCombo(state) {
    if (!state.down) return state;
    return { down: true, used: true, startedAt: state.startedAt };
}

function tapRelease(state, now, eligible, maximumMs) {
    const fire = state.down && !state.used && eligible && now >= state.startedAt
        && now - state.startedAt <= maximumMs;
    return { state: newTap(), fire: fire };
}

function overlayStep(phase, event) {
    if (event === "open") return phase === "Closed" || phase === "Closing" ? "Opening" : phase;
    if (event === "close") return phase === "Open" || phase === "Opening" ? "Closing" : phase;
    if (event === "opened") return phase === "Opening" ? "Open" : phase;
    if (event === "closed") return phase === "Closing" ? "Closed" : phase;
    return phase;
}

function validMode(mode) { return mode === "Sanctuary" || mode === "Workshop"; }

function modeTransition(currentMode, requestedMode) {
    if (!validMode(requestedMode)) return { accepted: false, nextMode: currentMode, changed: false };
    return { accepted: true, nextMode: requestedMode, changed: currentMode !== requestedMode };
}

function normalize(text) { return String(text || "").toLocaleLowerCase().trim(); }

function matchingApps(entries, query) {
    const needle = normalize(query);
    const available = entries.filter(function (entry) { return entry && entry.name && !entry.noDisplay; });
    const matches = needle ? available.filter(function (entry) {
        const haystack = [entry.name, entry.genericName, entry.comment, entry.id]
            .concat(entry.keywords || []).map(normalize).join(" ");
        return haystack.indexOf(needle) !== -1;
    }) : available;
    return matches.sort(function (a, b) { return a.name.localeCompare(b.name); });
}

function moveSelection(index, delta, count) {
    if (count < 1) return -1;
    return (Math.max(0, index) + delta + count) % count;
}

function protectedCategory(category, kind) {
    return category === "Protected" || kind === "terminal" || kind === "docker"
        || kind === "container" || kind === "database";
}

function safeWindowId(address) { return typeof address === "string" && /^0x[0-9a-f]+$/i.test(address); }

function validSnapshot(snapshot) {
    return snapshot && safeWindowId(snapshot.address) && Number.isInteger(snapshot.workspaceId)
        && snapshot.workspaceId !== 0 && Number.isFinite(snapshot.x) && Number.isFinite(snapshot.y)
        && Number.isFinite(snapshot.width) && Number.isFinite(snapshot.height)
        && snapshot.width > 0 && snapshot.height > 0;
}
