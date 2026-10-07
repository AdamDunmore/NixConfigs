import Gtk from "gi://Gtk";
import Pango from "gi://Pango";
import { createState, For } from "ags";

import MenuBar from "./menu_bar.tsx";
import MenuPage from "./menu_page.tsx";

import { Notification, history } from "../../utils/notif_history.ts";

export default function Notifications({ backCallback }: { backCallback: () => void }){
    return (
        <MenuPage>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <For each={history}>
                            {(n: Notification, i) => {
                                const [ focused, setFocused ] = createState<boolean>(false);
                                return (
                                    <button onClicked={() => setFocused(!focused())}>
                                        <box orientation={Gtk.Orientation.VERTICAL} class="menu_notification" css="background-color: rgba(0,0,0,0);">
                                            <box halign={Gtk.Align.START}>
                                                <image halign={Gtk.Align.START} iconName={(n.app_icon.slice(0,4) != "file") ? n.app_icon : ""} visible={n.app_icon.slice(0,4) != "file" || true}/>
                                                <label label={n.app_name} hexpand class="menu_notification_content"/>
                                            </box>
                                            <label class="menu_notification_content" label={n.summary} wrap wrap_mode={Pango.WrapMode.WORD_CHAR} />
                                            <label class="menu_notification_content" label={n.body} visible={focused} wrap wrap_mode={Pango.WrapMode.WORD_CHAR} />
                                        </box>
                                    </button>
                                )
                            }}
                        </For>
                    </box>
                </scrolledwindow>
            </box>
        </MenuPage>
    )
}
