import Gtk from "gi://Gtk";
import Network from "gi://AstalNetwork"
import { createState, For, } from "ags";

import MenuBar from "../menu_bar.tsx";

export default function Wifi({ backCallback, wifi }: { backCallback: () => void, wifi: Network.Wifi }){

    const [accessPoints, setAccessPoints] = createState([]);
    const [activeAccessPoint, setActiveAccessPoint] = createState(wifi.get_active_access_point());
    const [isTypingPassword, setIsTypingPassword] = createState(false);

    const handleWifi = () => {
        setAccessPoints(wifi.accessPoints);
        setActiveAccessPoint(wifi.get_active_access_point());
    }; handleWifi()

    wifi.connect("state-changed", () => {
        handleWifi()
    })

    wifi.connect("access-point-added", () => {
        handleWifi()
    })

    wifi.connect("access-point-removed", () => {
        handleWifi()
    })


    return (
        <box vexpand={true} hexpand={true}>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
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
}
