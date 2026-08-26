import Gtk from "gi://Gtk";

export default function MenuBar({ backCallback }: { backCallback: () => void }){
    return (
        <button class="menu_back_button" onClicked={() => backCallback()} label="󰌍" valign={Gtk.Align.START} halign={Gtk.Align.START}/>
    )
}
