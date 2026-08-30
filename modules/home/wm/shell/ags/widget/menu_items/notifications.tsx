import Gtk from "gi://Gtk";
import Gio from "gi://Gio";
import Pango from "gi://Pango";
import { createState, For, onCleanup } from "ags";

import MenuBar from "../menu_bar";

export default function Notifications({ backCallback }: { backCallback: () => void }){
    interface MakoNotification {
        id: number;
        app_name: string;
        summary: string;
        body: string;
        urgency: number;
    }

    const [ history, setHistory ] = createState<MakoNotification[]>([]);

    const proxy = Gio.DBusProxy.new_for_bus_sync(
        Gio.BusType.SESSION,
        Gio.DBusProxyFlags.NONE,
        null,
        "org.freedesktop.Notifications",
        "/fr/emersion/Mako",
        "fr.emersion.Mako",
        null,
    );

    const updateHistory = function(){
        const result = proxy.call_sync(
            "ListHistory",
            null,
            Gio.DBusCallFlags.NONE,
            -1,
            null
        );

        const h: MakoNotification[] = result.deepUnpack()[0].map((notification: any) => ({
            id: notification.id.deepUnpack(),
            app_name: notification["app-name"].deepUnpack(),
            summary: notification.summary.deepUnpack(),
            body: notification.body.deepUnpack(),
            urgency: notification.urgency.deepUnpack()
        }));
        setHistory(h)
    }

    const handler = proxy.connect(
        "g-properties-changed",
        updateHistory
    ); updateHistory();

    onCleanup(() => proxy.disconnect(handler));


    return (
        <box vexpand={true} hexpand={true}>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <For each={history}>
                            {(n: MakoNotification) => {
                                const [ focused, setFocused ] = createState<boolean>(false);
                                return (
                                    <button onClicked={() => setFocused(!focused())}>
                                        <box orientation={Gtk.Orientation.VERTICAL} class="menu_notification">
                                            <label label={n.app_name} halign={Gtk.Align.START}/>
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
        </box>
    )
}
