import Gtk from "gi://Gtk";
import GLib from "gi://GLib";
import { execAsync } from "ags/process";
import { createState } from "ags";

export default function PowerItems(){
    let [hovered, setHovered] = createState<boolean>(false);

    return (
        <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.START} spacing={5} class="menu_bar"
            $={(self) => {
                const motion = new Gtk.EventControllerMotion();

                motion.connect("enter", () => setHovered(true));
                motion.connect("leave", () => setHovered(false));

                self.add_controller(motion);
            }}
        >
            <button hexpand={true} onClicked={() => { execAsync("shutdown now") }} class="menu_button" label="⏻" />
            <revealer
                revealChild={hovered}
                transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                transitionDuration={400}
            >
                <box orientation={Gtk.Orientation.VERTICAL} spacing={5}>
                    <button hexpand={true} onClicked={() => { execAsync("reboot") }} class="menu_button" label="󰜉" />
                    <button hexpand={true} onClicked={() => { execAsync("systemctl suspend") }} class="menu_button" label="󰤄" />
                    <button hexpand={true} onClicked={() => { execAsync("hyprlock") }} class="menu_button" label="" />
                    <button hexpand={true} onClicked={() => { execAsync(["pkill", "-f", GLib.getenv("XDG_CURRENT_DESKTOP") ?? ""]) }} class="menu_button" label="󰍃" />
                </box>
            </revealer>
        </box>
    )
}
