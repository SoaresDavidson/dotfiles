hl.monitor({
    output = "HDMI-A-1",
    mode = "preferred",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "eDP-1",
    mode = "2560x1440@60",
    position = "2560x0",
    scale = 1.6,
})
for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i) ,
        monitor = "eDP-1",
        persistent = true,
        default = true,
    })
end
for i = 1, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-1",
    })
end
