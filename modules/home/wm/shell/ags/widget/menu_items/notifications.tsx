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
                            {(n: Notification) => {
                                const [ isInteracting, setIsInteracting ] = createState<boolean>(false);
                                return (
                                    <button>
                                        <Gtk.EventControllerMotion
                                            onEnter={() => setIsInteracting(true)}
                                            onLeave={() => setIsInteracting(false)}
                                        />
                                        <box orientation={Gtk.Orientation.VERTICAL} class="menu_notification" css="background-color: rgba(0,0,0,0);">
                                            <box halign={Gtk.Align.START} visible={isInteracting(i => (i || (n.app_icon != "" && n.app_icon.slice(0, 3) != "file")))}>
                                                <image halign={Gtk.Align.START} iconName={(n.app_icon.slice(0,4) != "file") ? n.app_icon : ""} visible={n.app_icon.slice(0,4) != "file" && n.app_icon != ""}/>
                                                <label visible={isInteracting(i => (i && n.app_name != ""))} label={n.app_name} hexpand class="menu_notification_content"/>
                                            </box>
                                            <label class="menu_notification_content" label={n.summary} wrap wrap_mode={Pango.WrapMode.WORD_CHAR} />
                                            <label class="menu_notification_content" css="font-size: 8px;" label={n.body} wrap wrap_mode={Pango.WrapMode.WORD_CHAR} />
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
