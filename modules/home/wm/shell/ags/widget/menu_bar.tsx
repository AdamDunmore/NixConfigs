import Gtk from "gi://Gtk";
export default function MenuBar({ backCallback, children }: { backCallback: () => void, children?: JSX.Element }){
    return (
        <box orientation={Gtk.Orientation.VERTICAL} class="menu_bar" spacing={5}>
            <button class="menu_button menu_back_button" onClicked={() => backCallback()} label="󰌍" valign={Gtk.Align.START} halign={Gtk.Align.START}/>
            <box orientation={Gtk.Orientation.VERTICAL} spacing={5}>
                {children}
            </box>
        </box>
    )
}
