-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- 1-5 on MONITOR1 (HDMI-A-1), 6-10 on MONITOR2 (eDP-1)
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR1, default = i == 1, persistent = true })
end
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR2, default = i == 6, persistent = true })
end
