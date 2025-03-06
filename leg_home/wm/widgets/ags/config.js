import menu from './windows/menu.js'
import power_warning from './windows/power_warning.js'
import bar from './windows/bar.js'
import notifications from './windows/notifications.js'
import bluetooth_menu from './windows/bluetooth_menu.js'

const Power_Warning_SH = power_warning("shutdown now");
const Power_Warning_RE = power_warning("reboot");
const Power_Warning_SW = power_warning("swaylock -C ~/.config/swaylock/config");

App.config({
    style: "./style.css",
    windows: [
        Power_Warning_SH,
        Power_Warning_RE,
        Power_Warning_SW,
        menu,
        bar,
        bluetooth_menu,
    ]
})


Power_Warning_SH.hide()
Power_Warning_RE.hide()
Power_Warning_SW.hide()
menu.hide()

//WIP
bluetooth_menu.hide()
