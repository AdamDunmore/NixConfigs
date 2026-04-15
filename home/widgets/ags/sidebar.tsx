import { Astal } from "ags/gtk4"
import { createState } from "ags"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"
import Mpris from "gi://AstalMpris";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){ 
    const mpris = Mpris.get_default();
    const [player, setPlayer] = createState({});

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

    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="container" orientation={1} vexpand={true}>
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
                <box vexpand={true} name="Spacer" />
                <button hexpand={true} onClicked={() => {execAsync("togglenight") }} class="button" label="" />
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


