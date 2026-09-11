import { createState, With } from "ags";
import { execAsync } from "ags/process";
import Gtk from "gi://Gtk";
import AstalBluetooth from "gi://AstalBluetooth"
import AstalNetwork from "gi://AstalNetwork"
import AstalPowerProfiles from "gi://AstalPowerProfiles"
import AstalBrightness from "gi://AstalBrightness"

import MenuSplitButton from "./menu_items/menu_split_button.tsx";
import Bluetooth from "./menu_items/bluetooth.tsx";
import System from "./menu_items/system.tsx";
import Wifi from "./menu_items/wifi.tsx";
import Notifications from "./menu_items/notifications.tsx";
import Mixer from "./menu_items/mixer.tsx";
import Calendar from "./menu_items/calendar.tsx";
import AstalWp from "gi://AstalWp?version=0.1";

export default function Menu(){
    const bluetooth: AstalBluetooth.Bluetooth = AstalBluetooth.get_default();
    const network: AstalNetwork.Network = AstalNetwork.get_default();
    const wifi: AstalNetwork.Wifi | null = network.get_wifi();
    const powerprofiles: AstalPowerProfiles.PowerProfiles = AstalPowerProfiles.get_default();
    const brightness: AstalBrightness.Brightness = AstalBrightness.get_default();
    const wireplumber: AstalWp.Wp = AstalWp.get_default();

    const [activeWindow, setActiveWindow] = createState<string>("none");
    const [powerProfile, setPowerProfile] = createState<string>("");
    const [isBluetoothPowered, setIsBluetoothPowered] = createState<boolean>(false);
    const [isWifiPowered, setIsWifiPowered] = createState<boolean>(false);
    const [speaker, setSpeaker] = createState<AstalWp.Endpoint>(wireplumber.get_default_speaker())
    const [getBrightness, setBrightness] = createState<number>(0);
    const [getVolume, setVolume] = createState<number>(0);

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

    const backlight = brightness.get_backlights().devices[0];
    backlight.connect("notify::brightness", () => {
        setBrightness(backlight.brightness) 
    }); setBrightness(backlight.brightness); 

    wireplumber.audio.connect("notify::speakers", () => {
        for (const s of wireplumber.audio.speakers) {
            if (s.get_is_default()) {
                setSpeaker(s);
                s.connect("notify::volume", () => {
                    if (s.volume !== undefined && Number.isFinite(s.volume))
                        setVolume(s.volume)
                }); if (s.volume !== undefined && Number.isFinite(s.volume)) setVolume(s.volume)
            }
        }
    });

    return (
        <box hexpand class="menu" valign={Gtk.Align.START} vexpand={false}>
            <With value={activeWindow}>
                {(w) => {
                    switch(w) {
                        case "system":
                            return ( <System backCallback={close} /> )
                        case "wifi":
                            return ( <Wifi network={network} backCallback={close}/> )
                        
                        case "bluetooth":
                            return ( <Bluetooth bluetooth={bluetooth} backCallback={close} /> )

                        case "notifications":
                            return ( <Notifications backCallback={close} /> )

                        case "mixer":
                            return ( <Mixer backCallback={close} /> )
                        
                        case "calendar":
                            return ( <Calendar backCallback={close} /> )

                        default:
                            return (
                                <box orientation={Gtk.Orientation.VERTICAL} vexpand class="menu menu_container" spacing={5}>
                                    <box orientation={Gtk.Orientation.HORIZONTAL} spacing={5} vexpand class="menu_button_container">
                                        <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.START} spacing={5}>
                                            <MenuSplitButton icon="" callback={() => {wifi?.set_enabled(!isWifiPowered())}} altCallback={() => { if(isWifiPowered()) { open("wifi") }}} enabled={isWifiPowered}/>
                                            <MenuSplitButton icon="󰍢" callback={() => { open("notifications") }}/>
                                            <MenuSplitButton icon="" callback={() => {open("system")}} />
                                            <MenuSplitButton icon={powerProfile(p => p == "performance" ? "" : "󱧥")} callback={() => { execAsync("powercycle") }}/>
                                        </box>
                                        <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.START} spacing={5}>
                                            <MenuSplitButton icon="" callback={() => {if (bluetooth.get_adapter()) { let adapter = bluetooth.get_adapter(); adapter.powered = !adapter.powered }}} altCallback={() => {if (isBluetoothPowered()) { open("bluetooth") }}} enabled={isBluetoothPowered} />
                                            <MenuSplitButton icon="󰃶" callback={() => { open("calendar") }}/>
                                            <MenuSplitButton icon="󱡫" callback={() => { open("mixer") }}/>
                                            <MenuSplitButton icon="󰊿" callback={() => { execAsync("translate") }}/>
                                        </box>
                                    </box>
                                    <box hexpand>
                                        <button class="menu_button" label={getBrightness(b => (b > 0.75) ? "󰃠" : (b > 0.25) ? "󰃟" : "󰃞")} onClicked={() => execAsync("togglenight")}/>
                                        <slider
                                            hexpand
                                            value={getBrightness}
                                            onChangeValue={(self) => {
                                                backlight.set_brightness(self.value)
                                            }}
                                        />
                                        <label label={getBrightness(b => `${(b * 100).toFixed()}%`)}/>
                                    </box>
                                    <box hexpand>
                                        <button class="menu_button" label={getVolume(v => (v > 0.80) ? "" : (v > 0.40) ? "" : (v > 0) ? "" : "")} onClicked={() => execAsync("sinkcycle")}/>
                                        <slider
                                            hexpand
                                            value={getVolume}
                                            onChangeValue={(self) => {
                                                speaker().set_volume(self.value)
                                            }}
                                        />
                                        <label label={getVolume(v => `${(v * 100).toFixed()}%`)}/>
                                    </box>
                                </box>
                            )
                    }
                }}
            </With>
        </box>
    );
}
