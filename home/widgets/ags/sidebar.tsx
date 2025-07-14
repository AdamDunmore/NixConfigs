import { Astal } from "ags/gtk4"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"

import UMpris from "./utils/mpris.ts";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    const mpris = new UMpris();

    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="container" orientation="1" vexpand={true}>
                <box class="mpris_box" valign={1}>
                    { mpris.getPlayerNames().map(name => (    
                        <label label={name}/>
                    )) }
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


