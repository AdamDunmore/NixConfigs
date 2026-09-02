import { Astal } from "ags/gtk4";
import app from "ags/gtk4/app";
import { Accessor, createState } from "ags";
import Gtk from "gi://Gtk";

import MprisItem from "./sidebar_items/mpris.tsx";

import { toggle_app } from "../scripts/window_managment.ts";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){ 
    const [isVisible, setIsVisible] = createState<boolean>(false);
    const [isWindowVisible, setIsWindowVisible] = createState<boolean>(false);

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
        if (cmd === "toggle_sidebar") {
            toggle_app(isWindowVisible, setIsWindowVisible, setIsVisible)
            response("ok")
        }
    })
    return (
        <window visible={isWindowVisible(v => v)} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <revealer class = "window" revealChild={isVisible(v => v)} transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT} transitionDuration={400} >
                <box orientation={1} vexpand={true}>
                    <MprisItem />
                </box>
            </revealer>
        </window>
    )
}


