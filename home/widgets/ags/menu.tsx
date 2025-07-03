import { Astal } from "ags/gtk4"

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Menu(){
    return (
        <window visible anchor={TOP | RIGHT | BOTTOM }>
            <box>Hello World</box>
        </window>
    )
}


