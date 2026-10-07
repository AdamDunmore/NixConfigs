import { createState } from "ags";
import Gio from "gi://Gio";
import GLib from "gi://GLib";
import { subprocess } from "ags/process";
import { readFileAsync } from "ags/file";

export interface Notification {
    id: number;
    app_icon: string;
    app_name: string;
    summary: string;
    body: string;
    urgency: number;
    actions: [];
}

export const [history, setHistory] = createState<Notification[]>([]);

export interface NotificationBackend {
    start(): void;
    updateHistory(): void;
}

const defaultBackend: NotificationBackend = (() => {
    let process: ReturnType<typeof subprocess> | null = null;

    const start = () => {
        updateHistory()
        process = subprocess(
            ["notification-monitor"],
            (stdout) => {
                updateHistory()
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
        const home = GLib.getenv("HOME")
        const path = `${home}/.local/share/ags_config/notifications.csv`; 
        let formated_content: Notification[] = [];
        readFileAsync(path)
            .then((content) => {
                content.split("\t\n").forEach((v) => {
                    if (v === "") return
                    const parsed_content = JSON.parse(v);
                    const formated_notification: Notification = {
                        id: parsed_content[1],
                        app_icon: parsed_content[6]["image-path"] ?? "", 
                        app_name: parsed_content[0],
                        summary: parsed_content[3],
                        body: parsed_content[4],
                        urgency: parsed_content[6]["urgency"],
                        actions: parsed_content[5]
                    };
                    formated_content.push(formated_notification)
                })
                setHistory(formated_content.reverse()) // Reverse to sort by newest
            })
            .catch(e => console.log(e))
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

export const backend: NotificationBackend =
hasName("fr.emersion.Mako")
    ? makoBackend
    : defaultBackend;
