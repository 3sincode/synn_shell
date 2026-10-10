-- Isolated nested-session candidate for later approval; never autoloaded.
-- No Synn shell, keybind module, service, or user config is started here.
-- This is a separate --config target, not a ~/.config/hypr file.

hl.env("HYPRLAND_NO_SD_VARS", "1")
hl.monitor({ output = "WAYLAND-1", mode = "1280x800@60", position = "0x0", scale = 1 })
hl.monitor({ output = "", disabled = true }) -- No fallback physical output.
hl.config({ misc = { disable_hyprland_logo = true, disable_splash_rendering = true } })

-- Emergency exit for the nested window only. Never use this in a UWSM session.
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exit(),
    { description = "Exit isolated Synn compositor trial" })
