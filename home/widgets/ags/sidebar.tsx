import { Astal } from "ags/gtk4"
import Mpris from "gi://AstalMpris"

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){
    return (
        <window visible anchor={TOP | RIGHT | BOTTOM }>
            <box>Hello World</box>
            <button valign = "end" onClicked={(self) => {}}>
                <label label="L" />
            </button>
        </window>
    )
}


