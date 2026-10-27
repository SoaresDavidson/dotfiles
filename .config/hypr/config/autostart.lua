-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("brave", { workspace = "1 silent" })
    -- PWA do WhatsApp Web (Brave); workspace definido pela window rule da classe
    hl.exec_cmd("sleep 3 && brave --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm")
    hl.exec_cmd("xhost +SI:localuser:root")
end)
