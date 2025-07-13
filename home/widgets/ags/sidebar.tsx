import { Astal } from "ags/gtk4"
import app from "ags/gtk4/app"
import { execAsync } from "ags/process"
import Mpris from "gi://AstalMpris"

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    return (
        <window visible={false} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <box class="power_box" valign="2">
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
        </window>
    )
}


