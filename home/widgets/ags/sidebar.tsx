import { Astal } from "ags/gtk4"
import { createState } from "ags"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"

import Mpris from "gi://AstalMpris";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    
    const mpris = Mpris.get_default();
    const [player, setPlayer] = createState({});
    
    mpris.connect("notify::players", () => {
        for (let p of mpris.players){
            if (p.identity == "Music Player Daemon"){
                setPlayer({
                    title: p.title.slice(0,30),
                    artist: p.artist.slice(0,30),
                    artUrl : p.artUrl.replace("file://", "")
                });
                p.connect("notify::metadata", () => {
                    setPlayer({
                        title: p.title.slice(0,30),
                        artist: p.artist.slice(0,30),
                        artUrl : p.artUrl.replace("file://", "")
                    });
                })
                return
            }
        }
    });

    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="container" orientation={1} vexpand={true}>
                <box class="mpris_box" valign={1} orientation={1}>
                    <box valign={1} orientation={1} spacing={6}>
                        <image
                          file={player(p => p?.artUrl ?? "undefined")}
                          pixelSize={128 + 64}
                        />
                        <label class="mpris_title" label={player(p => p?.title ?? "undefined")}/>
                        <label class="mpris_artist" label={player(p => p?.artist ?? "undefined")} />
                        <box halign={3} hexpand={true}>
                            <box spacing={8}>
                            <button onClicked={() => { execAsync("rmpc prev") }} class="button">
                                <label label=""/>
                            </button>
                            <button onClicked={() => { execAsync("rmpc togglepause") }} class="button">
                                <label label="󰐎"/>
                            </button>
                            <button onClicked={() => { execAsync("rmpc next") }} class="button">
                                <label label=""/>
                            </button>
                            </box>
                        </box>
                    </box>
                </box>
                <box vexpand={true} class="spacer" />
                <box class="power_box" valign={2} halign={3}>
                    <button onClicked={() => { execAsync("hyprlock") }} class="button">
                        <label label=""/>
                    </button>
                    <button onclicked={() => { execAsync("systemctl suspend") }} class="button">
                        <label label="󰤄"/>
                    </button>
                    <button onclicked={() => { execAsync("reboot") }} class="button">
                        <label label="󰜉"/>
                    </button>
                    <button onClicked={() => { execAsync("shutdown now") }} class="button">
                        <label label="⏻"/>
                    </button>
                </box>
            </box>
        </window>
    )
}


