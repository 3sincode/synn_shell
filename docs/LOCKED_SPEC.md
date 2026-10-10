# Synn — locked product requirements

Authority: `/home/sinn/Synn Dekstop/punya gweh.md`, user Stage B0 authorization of 2026-10-10. This document records product decisions; the Stage A source audit does not override them.

## Identity and project boundary

- User-facing brand: **Synn** exactly. Technical IDs are lowercase (`synn`, `synn-shell`, `synnd.service` if a shell-only daemon is ever justified).
- This repository `/home/sinn/Projects/synn-shell` is permanently independent from `/home/sinn/Projects/Synn`, the personal AI project. No shared daemon, database, IPC, API, packages, runtime dependencies, project-specific configuration, or future integration hooks. Do not modify the AI repository. Both may independently display “Synn”.
- No automatic mass-renaming of paths/imports. Preserve attribution for any future licensed upstream material.

## Session, modes, and lifecycle

- Target: Arch Linux, one Hyprland login session managed by UWSM, one Quickshell-based shell, optional **shell-only** service where needed, and exactly two runtime modes in that session.
- **Sanctuary** (`Super+I`) is calm/daily/music/wallpaper-first; **Workshop** (`Super+D`) supports development windows. Both use floating windows. Mode changes rearrange/present windows without logging out or restarting apps/services.
- Arena/Gaming mode, `Super+G`, dedicated game launcher/dashboard, and Synn-controlled GPU/game telemetry are removed decisions. Windows remains the preferred gaming environment.
- Auto-Close is **OFF** in both Sanctuary→Workshop and Workshop→Sanctuary. No mode switch terminates apps. Terminals and child sessions are permanently protected; Docker daemon, containers, databases and volumes must never be stopped by mode, idle, lock or cleanup. VS Code is not forcibly restarted. Application registry must represent Pinned, Protected, Mode-Owned, Shared and External. Future close actions require graceful shutdown, unsaved-work and recovery safeguards.
- Minimize/restore must not force a workspace switch; Alt+Tab switches windows in relevant current workspace, subject to validation.

## Dockless shared UX

- No app taskbar, bottom dock, hidden dock, edge-hover reveal or desktop icons. Bottom-edge cursor movement does nothing special. A slim top status bar is allowed and cannot become a running-app list.
- Tapping Super alone opens a search-first launcher with immediate input focus; typing filters apps, Enter launches/focuses, Esc dismisses. Modifier combinations, especially `Super+I/D`, must not flash the launcher. Web preview needs fallback controls where browser/compositor captures keys.
- One shared implementation/instance for launcher, bar, Overview, media player, EQ, Wi-Fi orbital, Bluetooth orbital, notifications, lock layer and system controls. Modes change only presentation/layout.

## Visual, media, and connectivity

- Nocturne Industrial: Carbon/Graphite, Steel/Pearl, restrained Teal/Amber/Coral. No purple-dominant or neon-overloaded default; comfortable type, restrained blur, anime wallpaper identity. Central motion tokens, reversible transitions, smooth pacing, reduced-motion and low-power paths.
- Floating player: circular cover, playback/progress, **ten-band graphic EQ** with Flat/Bass/Treble/Vocal and compatible presets. Preset changes interpolate handles and moving/glowing waveform. MPRIS playback data and actual DSP state must be separately verified; demo controls must be labeled demo.
- One orbital motion engine for Wi-Fi and Bluetooth with distinct accents. On: OFF→POWERING ON→SCANNING→NODES EMERGING→CONNECTED, nodes/links grow outward. Off: CONNECTED→POWERING OFF→COLLAPSING→OFF, rings/links/nodes retract inward. Real state/control comes from safe NetworkManager/BlueZ adapters, including errors and interrupted transitions.

## Lock and system safety

- Input inactivity governs idle, not the number of open windows. Design states: DesktopActive, Idle, PreLock, Locked, Authenticating, UnlockSuccess, ReturningToDesktop, Ready; `UnlockSuccess` requires actual authentication.
- The lock screen has a live/animated background and a smooth post-auth handoff where secure. Never use a fake overlay as a real locker. Choose audited hyprlock/ext-session-lock or correctly audited Quickshell `WlSessionLock` with real PAM. Wrong password stays locked; crash fails closed. If a seamless handoff cannot remain secure, use a graceful safe fallback.
- Pause background animation when display turns off; offer static, battery-saving and reduced-motion paths. Lock/unlock never stops ongoing terminal or Docker work.
- Preserve KDE Plasma and existing Caelestia as fallback. Hyprland/UWSM, packages, drivers, SDDM, PAM, systemd, Docker and home configuration changes require separately authorized deployment. Stage B0 changes only this repository.

## Preview boundary

The older browser prototype may visually simulate network and password entry, but it is not an OS bridge or secure lock. Stage B0 provides only a static shell foundation. Stage B1 and later features must meet the original specification's acceptance tests before deployment.
