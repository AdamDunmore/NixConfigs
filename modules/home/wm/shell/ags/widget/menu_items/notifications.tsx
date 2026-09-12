import Gtk from "gi://Gtk";
import Gio from "gi://Gio";
import GLib from "gi://GLib";
import Pango from "gi://Pango";
import { createState, For } from "ags";
import { subprocess } from "ags/process";

import MenuBar from "./menu_bar.tsx";
import MenuPage from "./menu_page.tsx";

export default function Notifications({ backCallback }: { backCallback: () => void }){
    interface Notification {
        id: number;
        app_icon: string;
        app_name: string;
        summary: string;
        body: string;
        urgency: number;
        actions: [];
    }

    interface NotificationBackend {
        start(): void;
        updateHistory(): void;
    }

    const [ history, setHistory ] = createState<Notification[]>([]);

    const defaultBackend: NotificationBackend = (() => {
        let process: ReturnType<typeof subprocess> | null = null;

        const start = () => {
            process = subprocess(
                ["notification-monitor"],
                (stdout) => {
                    for (const line of stdout.split("\n")) {
                        if (!line.trim())
                            continue;

                        try {
                            const notification: Notification =
                                JSON.parse(line);

                            setHistory([
                                notification,
                                ...history(),
                            ]);
                        } catch (e) {
                            console.error(
                                "Invalid notification:",
                                line,
                                e,
                            );
                        }
                    }
                },
                (stderr) => {
                    console.error(
                        "notification-monitor:",
                        stderr,
                    );
                },
            );
        };

        const updateHistory = () => {
            // Generic notification protocol has no history API.
        };

        return {
            start,
            updateHistory,
        };
    })();

    const makoBackend: NotificationBackend = (() => {
        const proxy = Gio.DBusProxy.new_for_bus_sync(
            Gio.BusType.SESSION,
            Gio.DBusProxyFlags.NONE,
            null,
            "org.freedesktop.Notifications",
            "/fr/emersion/Mako",
            "fr.emersion.Mako",
            null,
        );

        const updateHistory = () => {
            try {
                const result = proxy.call_sync(
                    "ListHistory",
                    null,
                    Gio.DBusCallFlags.NONE,
                    -1,
                    null,
                );

                const h: Notification[] = result.deepUnpack()[0].map(
                    (notification: any) => ({
                        id: notification.id.deepUnpack(),
                        app_icon: notification["app-icon"].deepUnpack(),
                        app_name: notification["app-name"].deepUnpack(),
                        summary: notification.summary.deepUnpack(),
                        body: notification.body.deepUnpack(),
                        urgency: notification.urgency.deepUnpack(),
                        actions: notification.actions.deepUnpack(),
                    }),
                );

                setHistory(h);
            } catch (e) {
                console.error(e);
            }
        };

        const start = () => {
            proxy.connect(
                "g-properties-changed",
                updateHistory,
            );

            updateHistory();
        };

        return {
            updateHistory,
            start,
        };
    })();

    const bus = Gio.bus_get_sync(Gio.BusType.SESSION, null);

    const hasName = (name: string): boolean =>
        bus.call_sync(
            "org.freedesktop.DBus",
            "/org/freedesktop/DBus",
            "org.freedesktop.DBus",
            "NameHasOwner",
            new GLib.Variant("(s)", [name]),
            new GLib.VariantType("(b)"),
            Gio.DBusCallFlags.NONE,
            -1,
            null,
        ).deepUnpack()[0];

    const backend: NotificationBackend =
    hasName("fr.emersion.Mako")
        ? makoBackend
        : defaultBackend;
    backend.start();

    return (
        <MenuPage>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <For each={history}>
                            {(n: Notification) => {
                                const [ focused, setFocused ] = createState<boolean>(false);
                                return (
                                    <button onClicked={() => setFocused(!focused())}>
                                        <box orientation={Gtk.Orientation.VERTICAL} class="menu_notification">
                                            <box hexpand>
                                                <image halign={Gtk.Align.START} iconName={(n.app_icon.slice(0,4) != "file") ? n.app_icon : "" }/>
                                                <label label={n.app_name} hexpand/>
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
