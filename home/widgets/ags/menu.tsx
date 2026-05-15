import { Astal } from "ags/gtk4";
import { createState, createEffect, For, With } from "ags";
import app from "ags/gtk4/app";
import Gtk from "gi://Gtk";
import Bluetooth from "gi://AstalBluetooth"

const { LEFT, BOTTOM } = Astal.WindowAnchor

export default function Menu(){
    const [isVisible, setIsVisible] = createState(false);
    const [isWindowVisible, setIsWindowVisible] = createState(false);
    const [activeWindow, setActiveWindow] = createState("none");
    const [devices, setDevices] = createState([]);
    const [discovering, setDiscovering] = createState(false);
    const [isBluetooth, setIsBluetooth] = createState(false);

    const TRANSITION_LENGTH: number = 500;

    const bluetooth = Bluetooth.get_default();

    const toggleCalled = () => {
        const v_status = isWindowVisible();
        if (!v_status) {
            setIsWindowVisible(!v_status);        
            setTimeout(() => { setIsVisible(!v_status) }, 1)
        } else{
            setIsVisible(!v_status);
            setTimeout(() => { setIsWindowVisible(!v_status) }, TRANSITION_LENGTH / 2)
        }
    };

    const open = (window) => {
        setActiveWindow(window);
    };

    const close = () => {
        setActiveWindow("none");
    };

    const handleBTConnection = (d) => {
        if(d.connected){
            d.disconnect_device((d) => print("Disconnecting"))
        }else {
            d.connect_device((d) => print("Connecting"))
        }
    }

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
      if (cmd === "toggle_menu") {
          toggleCalled()
      }

    while(!bluetooth.get_devices()){}
    if (bluetooth.isPowered){
        setIsBluetooth(true);
        setDevices(bluetooth.get_devices())
        bluetooth.connect("notify", () => { 
            setDevices(bluetooth.get_devices())
            setDiscovering(bluetooth.get_adapter().discovering);
        })
    }
    })

    return (
        <window visible={isWindowVisible(v => v)} name="menu" $={(self) => app.add_window(self)} anchor={BOTTOM | LEFT }> 
            <revealer
                class = "menu_window window"
                visible={isVisible(v => v)}
                revealChild={isVisible(v => v)}
                transitionDuration={TRANSITION_LENGTH}
                transitionType={Gtk.RevealerTransitionType.CROSSFADE}
            >
                <With value={activeWindow}>
                    {(w) => {
                        switch(w) {
                            case "wifi":
                                return (
                                    <box vexpand={true} hexpand={true} valign={Gtk.Align.START} halign={Gtk.Align.START}>
                                        <button class="menu_back_button" onClicked={() => close()} label="󰌍"/>
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
                                            <button vexpand={true} hexpand={true} class="menu_split_button menu_split_button_left" label="" />
                                            <button onClicked={() => {open("wifi")}} vexpand={true} hexpand={true} class="menu_split_button menu_split_button_right" label="" />
                                        </box>
                                        <box class="menu_split_button_container" orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>
                                            <button vexpand={true} hexpand={true} class="menu_split_button menu_split_button_left" label="" />
                                            <button onClicked={() => {open("bluetooth")}} vexpand={true} hexpand={true} class="menu_split_button menu_split_button_right" label="" />
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
