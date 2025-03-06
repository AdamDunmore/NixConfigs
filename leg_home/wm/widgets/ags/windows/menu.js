import device_info from '../modules/device_info.js'
import power_menu from '../modules/power_menu.js'
import volume_slider from '../modules/volume_slider.js'
import quick_settings from '../modules/quick_settings.js'
import player from '../modules/playing.js'


const Menu_Container = Widget.Box({
    className: "menu_container",
    orientation: 1,
    children: [
        Widget.Box({
            children: [
                Widget.Box({
                    orientation: 1,
                    children: [
                        quick_settings,
                        device_info,
                    ] 
                }),
                player
            ]
        }),
        Widget.Box({
            children: [
                power_menu,
                volume_slider,
            ]
        })
    ]
})

const Menu = Widget.Window({
    name: "menu",
    monitor: 1,
    className: "menu_window",
    child: Menu_Container
})

export default Menu;
