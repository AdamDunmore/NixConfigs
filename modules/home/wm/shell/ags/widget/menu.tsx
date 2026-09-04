import { createState, With } from "ags";
import { execAsync } from "ags/process";
import Gtk from "gi://Gtk";
import AstalBluetooth from "gi://AstalBluetooth"
import AstalNetwork from "gi://AstalNetwork"
import AstalPowerProfiles from "gi://AstalPowerProfiles"

import MenuSplitButton from "./menu_split_button.tsx";
import Bluetooth from "./menu_items/bluetooth.tsx";
import System from "./menu_items/system.tsx";
import Wifi from "./menu_items/wifi.tsx";
import Notifications from "./menu_items/notifications.tsx";
import Mixer from "./menu_items/mixer.tsx";
import PowerItems from "./power_items.tsx";

export default function Menu(){
    const bluetooth: AstalBluetooth.Bluetooth = AstalBluetooth.get_default();
    const network: AstalNetwork.Network = AstalNetwork.get_default();
    const wifi: AstalNetwork.Wifi | null = network.get_wifi();
    const powerprofiles: AstalPowerProfiles.PowerProfiles = AstalPowerProfiles.get_default();

    const [activeWindow, setActiveWindow] = createState<string>("none");
    const [powerProfile, setPowerProfile] = createState<string>("");
    const [isBluetoothPowered, setIsBluetoothPowered] = createState<boolean>(false);
    const [isWifiPowered, setIsWifiPowered] = createState<boolean>(false);

    const open = (window: string) => {
        setActiveWindow(window);
    };

    const close = () => {
        setActiveWindow("none");
    };

    wifi?.connect("access-point-added", () => {
        setIsWifiPowered(wifi.accessPoints.length > 0);

    });
    wifi?.connect("access-point-removed", () => {
        setIsWifiPowered(wifi.accessPoints.length > 0);
    })
    if (wifi) setIsWifiPowered(wifi.accessPoints.length > 0);

    const adapter = bluetooth.get_adapter();
    adapter?.connect("notify::powered", () => {
        setIsBluetoothPowered(adapter.powered);

    });
    if (adapter) setIsBluetoothPowered(adapter.powered);

    powerprofiles.connect("notify::active-profile", () => {
        setPowerProfile(powerprofiles.active_profile);
    }); setPowerProfile(powerprofiles.active_profile);

    return (
        <box valign={Gtk.Align.START} hexpand class="menu">
            <With value={activeWindow}>
                {(w) => {
                    switch(w) {
                        case "system":
                            return ( <System backCallback={close} /> )
                        case "wifi":
                            return ( <Wifi network={network} backCallback={close}/> )
                        
                        case "bluetooth": // TODO redesign
                            return ( <Bluetooth bluetooth={bluetooth} backCallback={close} /> )

                        case "notifications":
                            return ( <Notifications backCallback={close} /> )

                        case "mixer":
                            return ( <Mixer backCallback={close} /> )

                        default:
                            return (
                                <box orientation={Gtk.Orientation.HORIZONTAL}>
                                    <PowerItems />
                                    <box orientation={Gtk.Orientation.VERTICAL} spacing={5} valign={Gtk.Align.START}>
                                        <box hexpand spacing={5}>
                                            <MenuSplitButton icon="" callback={() => {wifi?.set_enabled(!isWifiPowered())}} altCallback={() => { if(isWifiPowered()) { open("wifi") }}} enabled={isWifiPowered}/>
                                            <MenuSplitButton icon="" callback={() => {if (bluetooth.get_adapter()) { let adapter = bluetooth.get_adapter(); adapter.powered = !adapter.powered }}} altCallback={() => {if (isBluetoothPowered()) { open("bluetooth") }}} enabled={isBluetoothPowered} />
                                        </box>
                                        <box hexpand spacing={5}>
                                            <MenuSplitButton icon={powerProfile(p => p == "performance" ? "" : "󱧥")} callback={() => { execAsync("powercycle") }}/>
                                            <MenuSplitButton icon="" callback={() => {open("system")}} />
                                        </box>
                                        <box hexpand spacing={5}>
                                            <MenuSplitButton icon="󰍢" callback={() => { open("notifications") }}/>
                                            <MenuSplitButton icon="󱡫" callback={() => { open("mixer") }}/>
                                        </box>
                                    </box>
                                </box>
                            )
                    }
                }}
            </With>
        </box>
    );
}
