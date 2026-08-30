import Gtk from "gi://Gtk";
import AstalBluetooth from "gi://AstalBluetooth"
import { createState, For } from "ags";

import MenuBar from "../menu_bar.tsx";

export default function Bluetooth({ bluetooth, backCallback }: { bluetooth: AstalBluetooth.Bluetooth, backCallback: () => void }){
    const [devices, setDevices] = createState<AstalBluetooth.Device[]>([]);
    const [discovering, setDiscovering] = createState<boolean>(false);

    const handleBTConnection = (d: AstalBluetooth.Device) => {
        if(d.connected){
            d.disconnect_device((d) => print("Disconnecting"))
        }else {
            d.connect_device((d) => print("Connecting"))
        }
    }

    const handleBluetooth = () => {
        setDevices(bluetooth.get_devices())
        setDiscovering(bluetooth.get_adapter().discovering);
    };
    bluetooth.connect("notify", () => { 
        handleBluetooth()
    }); if (bluetooth.isPowered){ handleBluetooth() }

    return (
        <box vexpand={true} hexpand={true} orientation={Gtk.Orientation.HORIZONTAL}>
            <MenuBar backCallback={backCallback}>
                <button class="menu_button" label={discovering(d => d ? "󰘊" : "")} onClicked={() => {
                            let a = bluetooth.get_adapter()
                            if (a && !a.discovering){
                                a.start_discovery()
                                setTimeout(() => { a.stop_discovery() }, 10000)
                            }
                        }}/>
            </MenuBar>
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box name="Bluetooth Box" orientation={1} spacing={4}>
                        <For each={devices}>
                            {(d: AstalBluetooth.Device) => {
                                if(d.name != null){
                                    return (
                                        <button onClicked={() => handleBTConnection(d)} class="menu_button">
                                            <box orientation={Gtk.Orientation.HORIZONTAL}>
                                                <image iconName={d.icon} halign={Gtk.Align.START}/>
                                                <label hexpand={true} label={devices(() => `${d.name.slice(0, 8)}`)} />
                                                <label visible={d.battery_percentage != -1 && d.connected} label={"[󰁹 " + (d.battery_percentage * 100) + "%]"} />
                                            </box>
                                        </button>
                                    )
                                } else { return (<box visible={false}/>) }
                            } }
                        </For>
                </box>
                </scrolledwindow>
            </box>
        </box>

    )
}
