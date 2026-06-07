import { Astal } from "ags/gtk4";
import { createState, createEffect, For, With } from "ags";
import app from "ags/gtk4/app";
import Gtk from "gi://Gtk";
import Bluetooth from "gi://AstalBluetooth"
import Network from "gi://AstalNetwork"

const { LEFT, BOTTOM } = Astal.WindowAnchor

export default function Menu(){
    const bluetooth = Bluetooth.get_default();
    const network = Network.get_default();
    const wifi = network.get_wifi();

    const [isVisible, setIsVisible] = createState(false);
    const [isWindowVisible, setIsWindowVisible] = createState(false);
    const [activeWindow, setActiveWindow] = createState("none");
    const [devices, setDevices] = createState([]);
    const [discovering, setDiscovering] = createState(false);
    const [isBluetooth, setIsBluetooth] = createState(false);
    const [isBluetoothPowered, setIsBluetoothPowered] = createState(false);
    const [isWifiPowered, setIsWifiPowered] = createState(false);
    const [accessPoints, setAccessPoints] = createState([]);
    const [activeAccessPoint, setActiveAccessPoint] = createState(wifi.get_active_access_point());
    const [isTypingPassword, setIsTypingPassword] = createState(false);

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

    const handleBTConnection = (d) => {
        if(d.connected){
            d.disconnect_device((d) => print("Disconnecting"))
        }else {
            d.connect_device((d) => print("Connecting"))
        }
    }

    const handleBluetooth = () => {
        setDevices(bluetooth.get_devices())
        setIsBluetoothPowered(bluetooth.get_adapter().powered);
    };
    while(!bluetooth.get_devices()){}
    if (bluetooth.isPowered){
        setIsBluetooth(true);
        handleBluetooth()
        bluetooth.connect("notify", () => { 
            handleBluetooth()
            setDiscovering(bluetooth.get_adapter().discovering);
        })
    }

    const handleWifi = () => {
        setIsWifiPowered(wifi.accessPoints.length > 0);
        setAccessPoints(wifi.accessPoints);
        setActiveAccessPoint(wifi.get_active_access_point());
    }; handleWifi()

    wifi.connect("state-changed", () => {
        handleWifi()
    })

    wifi.connect("access-point-removed", () => {
        handleWifi()
    })

    wifi.connect("access-point-removed", () => {
        handleWifi()
    })

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
                            case "wifi":
                                return (
                                    <box vexpand={true} hexpand={true}>
                                        <button class="menu_back_button" onClicked={() => close()} label="󰌍" valign={Gtk.Align.START} halign={Gtk.Align.START}/>
                                        <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                                            <scrolledwindow vexpand={true} hexpand={true} visible={isWifiPowered(w => w ? true : false)}>
                                                <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                                                    <button visible={isTypingPassword(b => b ? false : true)} label="Scan 󰘊" onClicked={() => { if(!wifi.scanning){ wifi.scan(); } }}/>
                                                    <box spacing={4} visible={isTypingPassword(b => b ? true : false)}>
                                                        <entry placeholderText="Password" hexpand={true} />
                                                        <button valign={Gtk.Align.CENTER} halign={Gtk.Align.END} label="<" onClicked={() => { setIsTypingPassword(false); }}/>
                                                        <button valign={Gtk.Align.CENTER} halign={Gtk.Align.END} label=">" onClicked={() => {
                                                            setIsTypingPassword(false);
                                                        }}/>
                                                    </box>
                                                    <For each={accessPoints}>
                                                        {(p) => {   
                                                            if(p.ssid != "") { return ( // TODO fix Logic Error
                                                                <button label={activeAccessPoint(a => `${p.ssid} ${(a != null && p.ssid == a.ssid) ? "%" : ""}`)} onClicked={() => {
                                                                    let a = activeAccessPoint();
                                                                    if (a == null || p.ssid != a.ssid){
                                                                        setIsTypingPassword(true); // Should only type if password is required
                                                                    } else {
                                                                        wifi.deactivate_connection(null);
                                                                    }
                                                                }}/>
                                                            ) }
                                                        }}
                                                    </For>
                                                </box>
                                            </scrolledwindow>
                                        </box>
                                    </box>
                                )
                            
                            case "bluetooth": // TODO redesign
                                return (
                                    <box vexpand={true} hexpand={true} orientation={Gtk.Orientation.HORIZONTAL}>
                                        <button class="menu_back_button" onClicked={() => close()} label="󰌍" valign={Gtk.Align.START} halign={Gtk.Align.START}/>
                                        <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                                            <scrolledwindow vexpand={true} hexpand={true} visible={isBluetooth(b => b ? true : false)}>
                                                <box name="Bluetooth Box" orientation={1} spacing={4}>
                                                    <button label={discovering(d => d ? "Bluetooth 󰘊" : "Bluetooth")} onClicked={() => {
                                                        let a = bluetooth.get_adapter()
                                                        if (!a.discovering){
                                                            a.start_discovery()
                                                            setTimeout(() => { a.stop_discovery() }, 10000)
                                                        }
                                                    }}/>
                                                    <For each={devices}>
                                                        {(d) => {
                                                            if(d.name != null){
                                                                return (<button label={devices(() => `${d.name.slice(0, 8)} ${(d.batterPercentage != -1 && d.connected) ? "[󰁹 " + (d.batteryPercentage * 100) + "%]" : ""}`)} onClicked={() => handleBTConnection(d)}/>)
                                                            } else { return (<box visible={false}/>) }
                                                        } }
                                                    </For>
                                            </box>
                                            </scrolledwindow>
                                        </box>
                                    </box>
                                )

                            default:
                                return (
                                    <box vexpand={true} hexpand={true} valign={Gtk.Align.START} halign={Gtk.Align.START}>
                                        <box class="menu_split_button_container" orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>
                                            <button vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_left ${isWifiPowered() ? "" : "disabled"}`} label="" onClicked={() => {wifi.set_enabled(!isWifiPowered())}}/>
                                            <button onClicked={() => {if(isWifiPowered()) {open("wifi")}}} vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_right ${isWifiPowered() ? "" : "disabled"}`} label="" />
                                        </box>
                                        <box class="menu_split_button_container" orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>
                                            <button onClicked={() => {if (isBluetooth()) { let adapter = bluetooth.get_adapter(); adapter.powered = !adapter.powered }}} vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_left ${isBluetoothPowered() ? "" : "disabled"}`} label="" />
                                            <button onClicked={() => {if (isBluetoothPowered()) {open("bluetooth")}}} vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_right ${isBluetoothPowered() ? "" : "disabled"}`} label="" />
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
