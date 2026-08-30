import Gtk from "gi://Gtk";
import Network from "gi://AstalNetwork"
import { createState, For, } from "ags";

import MenuBar from "../menu_bar.tsx";

export default function Wifi({ backCallback, wifi }: { backCallback: () => void, wifi: Network.Wifi }){

    const [accessPoints, setAccessPoints] = createState<Network.AccessPoint[]>([]);
    const [activeAccessPoint, setActiveAccessPoint] = createState(wifi.get_active_access_point());
    const [isTypingPassword, setIsTypingPassword] = createState(false);

    const handleWifi = () => {
        const uniqueAccessPoints = [...new Map(
            wifi.accessPoints.map(ap => [ap.ssid, ap])
        ).values()]
        setAccessPoints(uniqueAccessPoints);
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
            <MenuBar backCallback={backCallback}>
                <button class="menu_button" label="" visible={isTypingPassword(b => b ? false : true)} onClicked={() => { if(!wifi.scanning){ wifi.scan(); } }}/>
            </MenuBar>
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <box spacing={4} visible={isTypingPassword(b => b ? true : false)}>
                            <entry placeholderText="Password" hexpand={true} />
                            <button valign={Gtk.Align.CENTER} halign={Gtk.Align.END} label="<" onClicked={() => { setIsTypingPassword(false); }}/>
                            <button valign={Gtk.Align.CENTER} halign={Gtk.Align.END} label=">" onClicked={() => {
                                setIsTypingPassword(false);
                            }}/>
                        </box>
                        <For each={accessPoints}>
                            {(access_point: Network.AccessPoint) => {   
                                return (
                                    <button 
                                        visible={access_point.ssid != null}
                                        label={ activeAccessPoint(active_access_point => access_point.ssid +
                                            `${(access_point.ssid == active_access_point?.ssid) ? `  ${access_point.strength}%` : ""}`
                                        )} 
                                        onClicked={() => {
                                            let active_access_point = activeAccessPoint();
                                            if (active_access_point == null || access_point.ssid != active_access_point.ssid){
                                                // access_point.activate(null, (self, res, data) => {
                                                // })

                                                // setIsTypingPassword(true);
                                            } else {
                                                wifi.deactivate_connection(null);
                                            }
                                        }
                                    }/>
                                )
                            }}
                        </For>
                    </box>
                </scrolledwindow>
            </box>
        </box>
    )
}
