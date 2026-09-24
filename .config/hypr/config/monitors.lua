-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Outputs are defined in variables.lua (MONITOR1 = HDMI-A-1, MONITOR2 = eDP-1)

hl.monitor({
    output   = MONITOR1,
    disabled = false,
    mode     = "2560x1080@74.99Hz",
    position = "0x0",
    scale    = 1,
    cm       = "srgb",
})

hl.monitor({
    output   = MONITOR2,
    disabled = false,
    mode     = "2560x1600@60.00Hz",
    position = "2560x0",
    scale    = 1.6,
    cm       = "srgb",
})
