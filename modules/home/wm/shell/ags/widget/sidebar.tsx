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
                transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            >
                <box orientation={1} vexpand={true}>
                    <MprisItem />
                    <button valign={2} hexpand={true} onClicked={() => {execAsync("togglenight") }} class="button" label="" />
                    <box valign={2}>
                        <button hexpand={true} onClicked={() => { execAsync("hyprlock") }} class="sidebar_power_button" label="" />
                        <button hexpand={true} onclicked={() => { execAsync("systemctl suspend") }} class="sidebar_power_button" label="󰤄" />
                        <button hexpand={true} onclicked={() => { execAsync("reboot") }} class="sidebar_power_button" label="󰜉" />
                        <button hexpand={true} onClicked={() => { execAsync("shutdown now") }} class="sidebar_power_button" label="⏻" />
                    </box>
                </box>
            </revealer>
        </window>
    )
}


