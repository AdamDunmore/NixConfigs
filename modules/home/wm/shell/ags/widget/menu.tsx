import { Astal } from "ags/gtk4";
import { createState, With } from "ags";
import app from "ags/gtk4/app";
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

const { LEFT, BOTTOM } = Astal.WindowAnchor

export default function Menu(){
    const bluetooth: AstalBluetooth.Bluetooth = AstalBluetooth.get_default();
    const network: AstalNetwork.Network = AstalNetwork.get_default();
    const wifi: AstalNetwork.Wifi | null = network.get_wifi();
    const powerprofiles: AstalPowerProfiles.PowerProfiles = AstalPowerProfiles.get_default();

    const [isVisible, setIsVisible] = createState<boolean>(false);
    const [isWindowVisible, setIsWindowVisible] = createState<boolean>(false);
    const [activeWindow, setActiveWindow] = createState<string>("none");
    const [powerProfile, setPowerProfile] = createState<string>("");
    const [isBluetoothPowered, setIsBluetoothPowered] = createState<boolean>(false);
    const [isWifiPowered, setIsWifiPowered] = createState<boolean>(false);

    const TRANSITION_LENGTH: number = 200;

    const open = (window: string) => {
        setActiveWindow(window);
    };

    const close = () => {
        setActiveWindow("none");
    };

    const toggleCalled = () => {
        const v_status = isWindowVisible();
        if (!v_status) {
            setIsWindowVisible(!v_status);        
            setTimeout(() => { setIsVisible(!v_status) }, 1)
            close()
        } else{
            setIsVisible(!v_status);
            setTimeout(() => { setIsWindowVisible(!v_status) }, TRANSITION_LENGTH / 2)
        }
    };

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
        if (cmd === "toggle_menu") {
            toggleCalled()
            response("ok")
        }
    })

    wifi.connect("access-point-added", () => {
        setIsWifiPowered(wifi.accessPoints.length > 0);
    }); setIsWifiPowered(wifi.accessPoints.length > 0);

    const adapter = bluetooth.get_adapter();
    adapter.connect("notify::powered", () => {
        setIsBluetoothPowered(adapter.powered);
    }); setIsBluetoothPowered(adapter.powered);

    powerprofiles.connect("notify::active-profile", () => {
        setPowerProfile(powerprofiles.active_profile);
    }); setPowerProfile(powerprofiles.active_profile);

    return (
        <window visible={isWindowVisible(v => v)} name="menu" $={(self) => app.add_window(self)} anchor={BOTTOM | LEFT } keymode={Astal.Keymode.ON_DEMAND}> 
            <revealer
                class = "menu_window window"
                revealChild={isVisible(v => v)} // Broken?
                transitionDuration={TRANSITION_LENGTH}
                transitionType={Gtk.RevealerTransitionType.CROSSFADE}
            >
                <With value={activeWindow}>
                    {(w) => {
                        switch(w) {
                            case "system":
                                return ( <System backCallback={close} /> )
                            case "wifi":
                                return ( <Wifi wifi={wifi} backCallback={close}/> )
                            
                            case "bluetooth": // TODO redesign
                                return ( <Bluetooth bluetooth={bluetooth} backCallback={close} /> )

                            case "notifications":
                                return ( <Notifications backCallback={close} /> )

                            default:
                                return (
                                    <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.START}>
                                        <box vexpand={true} hexpand={true} valign={Gtk.Align.START} halign={Gtk.Align.START}>
                                            <MenuSplitButton icon="" callback={() => {wifi?.set_enabled(!isWifiPowered())}} altCallback={() => { if(isWifiPowered()) { open("wifi") }}} enabled={isWifiPowered}/>
                                            <MenuSplitButton icon="" callback={() => {if (isBluetooth()) { let adapter = bluetooth.get_adapter(); adapter.powered = !adapter.powered }}} altCallback={() => {if (isBluetoothPowered()) { open("bluetooth") }}} enabled={isBluetoothPowered} />
                                            <MenuSplitButton icon="" callback={() => {open("system")}} />
                                        </box>
                                        <box vexpand={true} hexpand={true} valign={Gtk.Align.START} halign={Gtk.Align.START}>
                                            <MenuSplitButton icon={powerProfile(p => p == "performance" ? "" : "󱧥")} callback={() => { execAsync("powercycle") }}/>
                                            <MenuSplitButton icon="󰍢" callback={() => { open("notifications") }}/>
                                        </box>
                                    </box>
                                )
                        }
                    }}
                </With>
            </revealer>
        </window>
    );
}
