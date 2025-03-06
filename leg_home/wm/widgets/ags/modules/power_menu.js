const power_profiles = await Service.import("powerprofiles");

function toggleProfiles(){
    switch(power_profiles.active_profile){
        case 'balanced':
            power_profiles.active_profile = 'performance';
            break;
        case 'performance':
            power_profiles.active_profile = 'power-saver';
            break;
        case 'power-saver':
            power_profiles.active_profile = 'balanced';
            break;
        default:
            power_profiles.active_profile = 'balanced';
    }
}

const PowerProfile = Widget.Button({
    className: "power_button",
    label: power_profiles.bind('active_profile'),
    on_clicked: () => toggleProfiles()
})

const Power_Off = Widget.Button({
    label: "󰐥",
    className: "power_button",
    on_clicked: () => {Utils.execAsync("ags -t 'power_warning:sh'"); Utils.execAsync("ags -t 'menu'");}
})

const Power_Restart = Widget.Button({
    label: "",
    className: "power_button",
    on_clicked: () => {Utils.execAsync("ags -t 'power_warning:re'"); Utils.execAsync("ags -t 'menu'");}
})

const Power_Lock = Widget.Button({
    label: "",
    className: "power_button",
    on_clicked: () => {Utils.execAsync("ags -t 'power_warning:sw'"); Utils.execAsync("ags -t 'menu'");}
})

const Power = Widget.Box({
    className: "power_menu",
    orientation: 0,
    spacing: 20,
    hpack: "center",
    children: [
        Power_Off,
        Power_Restart,
        Power_Lock,
    ]
})

export default Power
