-- Synn Stage B1 review module for Hyprland 0.56 Lua configuration.
-- This file is not loaded by the isolated trial config or the user's config.
-- It requires a single running Synn shell instance to register the names.
-- Review existing binds before including this file in a later test session.

hl.bind("SUPER + I", hl.dsp.global("synn-shell:sanctuary"),
    { description = "Synn Sanctuary" })
hl.bind("SUPER + D", hl.dsp.global("synn-shell:workshop"),
    { description = "Synn Workshop" })
hl.bind("SUPER + Tab", hl.dsp.global("synn-shell:overview"),
    { description = "Synn Overview" })

-- DISABLED: even a release-only bind is not proven to suppress all other
-- Super combinations on this compositor and keyboard. The QML tap arbiter
-- handles repeats, holds, fullscreen, and combos it observes, but cannot
-- infer unrelated binds that Hyprland never forwards to it.
-- Do not enable before the isolated collision matrix passes.
-- hl.bind("Super_L", hl.dsp.global("synn-shell:super-tap"),
--     { description = "Synn launcher" })
