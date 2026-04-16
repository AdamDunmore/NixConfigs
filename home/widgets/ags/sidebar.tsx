import { Astal } from "ags/gtk4"
import { createState, createEffect, For } from "ags"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"
import Mpris from "gi://AstalMpris";
import Bluetooth from "gi://AstalBluetooth"

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){ 
    const [player, setPlayer] = createState({});
    const [devices, setDevices] = createState([]);
    const [discovering, setDiscovering] = createState(false);
    const [isBluetooth, setIsBluetooth] = createState(false);

    const mpris = Mpris.get_default();
    const bluetooth = Bluetooth.get_default();

    const MAX_TITLE_LENGTH: number = 30;

    const updatePlayer = (p) => {
        setPlayer({
            title: p.title.slice(0,MAX_TITLE_LENGTH - 10),
            artist: p.artist.slice(0,MAX_TITLE_LENGTH),
            artUrl : p.artUrl.replace("file://", ""),
            playbackStatus : p.playbackStatus,
            volume: p.volume,
        });
    };

    const handleBTConnection = (d) => {
        if(d.connected){
            d.disconnect_device((d) => print("Disconnecting"))
        }else {
            d.connect_device((d) => print("Connecting"))
        }
    }

    mpris.connect("notify::players", () => {
        for (let p of mpris.players){
            if (p.identity == "Music Player Daemon"){
                updatePlayer(p);
                p.connect("notify::metadata", () => {
                    updatePlayer(p);
                })
                return
            }
        }
    });

    while(!bluetooth.get_devices()){}
    if (bluetooth.isPowered){
        setIsBluetooth(true);
        setDevices(bluetooth.get_devices())
        bluetooth.connect("notify", () => { 
            setDevices(bluetooth.get_devices())
            setDiscovering(bluetooth.get_adapter().discovering);
        })
    }
    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="parent" orientation={1} vexpand={true}>
                <box valign={1} halign={3} orientation={1} spacing={6} name="Mpris Box">
                    <image
                        file={player(p => p?.artUrl ?? "undefined")}
                        pixelSize={128 + 64}
                    />
                    <label class="mpris_title" label={player(p => p?.title ?? "No Title")}/>
                    <label class="mpris_artist" label={player(p => p?.artist ?? "No Artist")} />
                    <box spacing={8}>
                        <button hexpand={true} onClicked={() => { execAsync("rmpc prev") }} class="button" label="" />
                        <button hexpand={true} onClicked={() => { execAsync("rmpc togglepause") }} class="button" label={player(p => p?.playbackStatus ? "" : "")} />
                        <button hexpand={true} onClicked={() => { execAsync("rmpc next") }} class="button" label="" />
                    </box>
                    <box spacing={8}>
                        <button hexpand={true} onClicked={() => { execAsync("rmpc volume -5") }} class="button" label="󰝞" />
                        <label class="button" label={player(p => `${p.volume * 100}%`)} /> { /* Not a button but oh well */ }
                        <button hexpand={true} onClicked={() => { execAsync("rmpc volume +5") }} class="button" label="󰝝" />
                    </box>
                </box>
                <box vexpand={true} visible={isBluetooth(b => b ? false : true)}/>
                <scrolledwindow maxContentHeight={600} vexpand={true} visible={isBluetooth(b => b ? true : false)}>
                    <box name="Bluetooth Box" orientation={1} spacing={4} class="container">
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
                <button valign={2} hexpand={true} onClicked={() => {execAsync("togglenight") }} class="button" label="" />
                <box class="power_box" valign={2}>
                    <button hexpand={true} onClicked={() => { execAsync("hyprlock") }} class="button" label="" />
                    <button hexpand={true} onclicked={() => { execAsync("systemctl suspend") }} class="button" label="󰤄" />
                    <button hexpand={true} onclicked={() => { execAsync("reboot") }} class="button" label="󰜉" />
                    <button hexpand={true} onClicked={() => { execAsync("shutdown now") }} class="button" label="⏻" />
                </box>
            </box>
        </window>
    )
}


