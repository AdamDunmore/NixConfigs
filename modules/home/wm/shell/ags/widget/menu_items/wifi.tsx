import Gtk from "gi://Gtk";
import Network from "gi://AstalNetwork"
import { createState, For, } from "ags";
import { execAsync } from "ags/process";

import MenuBar from "../menu_bar.tsx";

export default function Wifi({ backCallback, network }: { backCallback: () => void, network: Network.Network }){
    const wifi: Network.Wifi | null = network.get_wifi();

    const [accessPoints, setAccessPoints] = createState<Network.AccessPoint[]>([]);
    const [activeAccessPoint, setActiveAccessPoint] = createState(wifi.get_active_access_point());
    const [newActiveAccessPoint, setNewActiveAccessPoint] = createState<string | Network.AccessPoint>("none");
    const [currentPassword, setCurrentPassword] = createState<string>("");

    const handleWifi = () => {
        const uniqueAccessPoints = [...new Map(
            wifi.accessPoints.map(ap => [ap.ssid, ap])
        ).values()]
        setAccessPoints(uniqueAccessPoints);
        setActiveAccessPoint(wifi.get_active_access_point());
    }; handleWifi()

    const handleConnection = function(){
        const ap = newActiveAccessPoint();
        const p = currentPassword();
        if (typeof ap !== "string"){
            ap.activate(p, null);
        }
        setNewActiveAccessPoint("none")
        setCurrentPassword("");
    }

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
            <MenuBar backCallback={backCallback}>
                <button class="menu_button" label="" onClicked={() => { if(!wifi.scanning){ wifi.scan(); } }}/>
            </MenuBar>
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true} spacing={2}>
                <box spacing={4} visible={newActiveAccessPoint(t => t !== "none")}>
                    <button class="menu_button" valign={Gtk.Align.CENTER} halign={Gtk.Align.START} label="" onClicked={() => { setNewActiveAccessPoint("none") }}/>
                    <button class="menu_button" valign={Gtk.Align.CENTER} halign={Gtk.Align.START} label="󰌑" onClicked={handleConnection}/>
                    <entry placeholderText={newActiveAccessPoint(ap => `${ap.ssid} password`)} hexpand={true} onNotifyText={t => setCurrentPassword(t.text)} onActivate={handleConnection}/>
                </box>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <For each={accessPoints}>
                            {(access_point: Network.AccessPoint) => {   
                                return (
                                    <button 
                                        visible={access_point.ssid != null}
                                        class="menu_button"
                                        onClicked={() => {
                                            let active_access_point = activeAccessPoint();
                                            if (active_access_point != null && access_point.ssid === active_access_point.ssid){
                                                wifi?.deactivate_connection(null);
                                                return;
                                            }

                                            execAsync(`nmcli device wifi connect ${access_point.bssid}`)
                                                .then(() => console.log(`Network: connected to '${access_point.ssid}'`))
                                                .catch((err) => {
                                                    if (String(err).includes("Secrets were required")) {
                                                        setNewActiveAccessPoint(access_point);
                                                    } else { 
                                                        console.error("Connection Failed: " + err);
                                                    }
                                                });
                                        }
                                    }>
                                        <box orientation={Gtk.Orientation.HORIZONTAL}>
                                            <image icon_name={access_point.icon_name} />
                                            <label hexpand={true} label={access_point.ssid}/>
                                            <label visible={activeAccessPoint(a => a?.ssid == access_point.ssid)} label={`[ ${access_point.strength}%]`} />
                                        </box>
                                    </button>
                                )
                            }}
                        </For>
                    </box>
                </scrolledwindow>
            </box>
        </box>
    )
}
