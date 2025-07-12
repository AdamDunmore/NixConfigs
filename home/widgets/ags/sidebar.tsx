import { Astal } from "ags/gtk4"
import { execAsync } from "ags/process"
import Mpris from "gi://AstalMpris"

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    return (
        <window visible anchor={TOP | RIGHT | BOTTOM }>
            <box>
                <button onClicked={(self) => { execAsync("hyprlock") }}>
                    <label label="L" />
                </button>
                <button onClicked={(self) => { execAsync("systemctl suspend") }}>
                    <label label="S" />
                </button>
                <button onClicked={(self) => { execAsync("shutdown now") }}>
                    <label label="P" />
                </button>
            </box>
        </window>
    )
}


