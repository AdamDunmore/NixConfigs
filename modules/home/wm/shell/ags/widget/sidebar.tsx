import { Astal } from "ags/gtk4";
import app from "ags/gtk4/app";
import { execAsync } from "ags/process";
import { createState } from "ags";
import Gtk from "gi://Gtk";

import MprisItem from "./sidebar_items/mpris.tsx";

const { TOP, RIGHT, BOTTOM } = Astal.WindowAnchor

export default function Sidebar(){ 
    const [isVisible, setIsVisible] = createState(false);
    const [isWindowVisible, setIsWindowVisible] = createState(false);

    const TRANSITION_LENGTH: number = 500;

    const toggleCalled = () => {
        const v_status = isWindowVisible();
        if (!v_status) {
            setIsWindowVisible(!v_status);        
            setTimeout(() => { setIsVisible(!v_status) }, 1)
        } else{
            setIsVisible(!v_status);
            setTimeout(() => { setIsWindowVisible(!v_status) }, TRANSITION_LENGTH / 2)
        }
    };

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
        if (cmd === "toggle_sidebar") {
            toggleCalled()
            response("ok")
        }
    })
    return (
        <window visible={isWindowVisible(v => v)} name="sidebar" $={(self) => app.add_window(self)} anchor={TOP | RIGHT | BOTTOM }>
            <revealer
                class = "window"
                revealChild={isVisible(v => v)}
                transitionDuration={TRANSITION_LENGTH}
                transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
            >
                <box orientation={1} vexpand={true}>
                    <MprisItem />
                    <box valign={Gtk.Align.END} halign={Gtk.Align.END} orientation={Gtk.Orientation.VERTICAL}>

                    </box>
                </box>
            </revealer>
        </window>
    )
}


