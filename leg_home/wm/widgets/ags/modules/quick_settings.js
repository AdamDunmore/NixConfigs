const network = await Service.import("network");
import bluetooth from '../services/bluetooth.js';

function toggleWifi(active){
    if(network.wifi.enabled != active){
       network.toggleWifi() 
    }
}

function toggleBluetooth(active){
    if(bluetooth.state != active){
        bluetooth.toggleBluetooth()
    }
}

const Wifi = Widget.CenterBox({
    className: "quick_setting_container",
    center_widget: Widget.ToggleButton({
        className: "quick_setting",
        hexpand:true,
        vexpand: true,
        label: "󰖩",
        onToggled: (state) => toggleWifi(state.active),
        setup: (self) => {
            Utils.interval(500, () => {
                if (network.wifi.enabled == true){
                    self.set_active(true)
                }
                else{
                    self.set_active(false)
                }
            })
        }
    }),
})
const Bluetooth = Widget.CenterBox({
    className: "quick_setting_container",
    center_widget: Widget.ToggleButton({
        className: "quick_setting",
        hexpand:true,
        vexpand: true,
        hpack: "center",
        vpack: "center",
        label: "",
        onToggled: (state) => toggleBluetooth(state.active),
        setup: (self) => {
            bluetooth.connect('state-changed', (data) => {
                const state = data.state
                if (state){
                    self.set_active(true);
                }
                else{
                    self.set_active(false);
                }
            })
        }
    }),
})
const Settings = Widget.Box({
    orientation: 0,
    children: [
        Wifi,
        Bluetooth,
    ]
})

export default Settings;
