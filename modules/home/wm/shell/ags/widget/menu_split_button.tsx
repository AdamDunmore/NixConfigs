import Gtk from "gi://Gtk";
import { Accessor } from "ags";

export default function MenuSplitButton({ icon, callback, altCallback, enabled }: { icon: string | Accessor<string>, callback: () => void, altCallback?: () => void, enabled?: Accessor }){
    return (
        <box class="menu_split_button_container" orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.CENTER} halign={Gtk.Align.CENTER}>
            <button vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_left ${enabled && !enabled() ? "disabled" : "" } ${altCallback ? "" : "menu_split_button_right"}`} label={icon} onClicked={callback}/>
            <button onClicked={altCallback} vexpand={true} hexpand={true} class={`menu_split_button menu_split_button_right ${enabled && !enabled() ? "disabled" : ""}`} label="" visible={altCallback ? true : false}/>
        </box>
    )
}
