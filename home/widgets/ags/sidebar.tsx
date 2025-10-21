import { Astal } from "ags/gtk4"
import Mpris from "gi://AstalMpris";
import { createState } from "ags"
import app from "ags/gtk4/app"
import { execAsync, exec } from "ags/process"

import UMpris from "./utils/mpris.ts";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    
    // const [playing , setPlaying] = createState(mpris.getPlayingPlayer())
    const mpris = Mpris.get_default();


    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="container" orientation={1} vexpand={true}>
                <box class="mpris_box" valign={1} orientation={1}>
                    {// () => mpris.players.map(p => ( 
                     //   <box>
                     //       <label label={p.identity}/>
                     //       <label label={`${p.playback_status}`}/>
                     //   </box>
                    //))
                        }
                    { // bind(mpris, "players").as(players => (
                      //   <label label={players[0].identity}/>
                      // )) 
                    }
                </box>
                <box vexpand={true} class="spacer" />

                <box class="power_box" valign={2}>
                    <button onClicked={(self) => { execAsync("hyprlock") }} class="power_button">
                        <label label=""/>
                    </button>
                    <button onclicked={(self) => { execAsync("systemctl suspend") }} class="power_button">
                        <label label="󰤄"/>
                    </button>
                    <button onclicked={(self) => { execAsync("reboot") }} class="power_button">
                        <label label="󰜉"/>
                    </button>
                    <button onClicked={(self) => { execAsync("shutdown now") }} class="power_button">
                        <label label="⏻"/>
                    </button>
                </box>
            </box>
        </window>
    )
}


