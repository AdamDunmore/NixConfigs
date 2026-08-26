import { Astal } from "ags/gtk4";
import { createState, With } from "ags";
import app from "ags/gtk4/app";
import Gtk from "gi://Gtk";
import AstalBluetooth from "gi://AstalBluetooth"
import AstalNetwork from "gi://AstalNetwork"

import MenuSplitButton from "./menu_split_button.js";
import Bluetooth from "./menu_items/bluetooth.tsx";
import System from "./menu_items/system.tsx";
import Wifi from "./menu_items/wifi.tsx";

const { LEFT, BOTTOM } = Astal.WindowAnchor

export default function Menu(){
    const bluetooth = AstalBluetooth.get_default();
    const network = AstalNetwork.get_default();
    const wifi = network.get_wifi();

    const [isVisible, setIsVisible] = createState(false);
    const [isWindowVisible, setIsWindowVisible] = createState(false);
    const [activeWindow, setActiveWindow] = createState("none");
    const [isBluetoothPowered, setIsBluetoothPowered] = createState(false);
    const [isWifiPowered, setIsWifiPowered] = createState(false);

    const TRANSITION_LENGTH: number = 200;

    const open = (window) => {
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

    wifi.connect("notify", () => {
        setIsWifiPowered(wifi.accessPoints.length > 0);
    }); setIsWifiPowered(wifi.accessPoints.length > 0);

    bluetooth.connect("notify", () => {
        setIsBluetoothPowered(bluetooth.get_adapter().powered);
    }); setIsBluetoothPowered(bluetooth.get_adapter().powered);

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

                            default:
                                return (
                                    <box vexpand={true} hexpand={true} valign={Gtk.Align.START} halign={Gtk.Align.START}>
                                        <MenuSplitButton icon="" callback={() => {wifi?.set_enabled(!isWifiPowered())}} altCallback={() => { if(isWifiPowered()) { open("wifi") }}} enabled={isWifiPowered}/>
                                        <MenuSplitButton icon="" callback={() => {if (isBluetooth()) { let adapter = bluetooth.get_adapter(); adapter.powered = !adapter.powered }}} altCallback={() => {if (isBluetoothPowered()) { open("bluetooth") }}} enabled={isBluetoothPowered} />
                                        <MenuSplitButton icon="" callback={() => {open("system")}} />
                                    </box>
                                )
                        }
                    }}
                </With>
            </revealer>
        </window>
    );
}
