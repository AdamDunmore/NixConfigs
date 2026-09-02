import { Accessor, For, createState, createEffect } from "ags";
import Gtk from "gi://Gtk";
import Gdk from "gi://Gdk";
import Apps from "gi://AstalApps"

export default function AppMenu({ app_visible, close } : { app_visible: Accessor<boolean>, close: () => void }){
    const apps = new Apps.Apps({
        nameMultiplier: 2,
        entryMultiplier: 0,
        executableMultiplier: 2,
    })

    const [appsList, setAppsList] = createState<Apps.Application[]>([]);
    const [selected, setSelected] = createState<number>(0);

    let scrolled: Gtk.ScrolledWindow;
    let viewport: Gtk.Viewport;
    const buttons: Gtk.Button[] = [];

    createEffect(() => {
        const index = selected();
        const button = buttons[index];

        if (button) {
            viewport.scroll_to(button, null);
        }
    });

    setAppsList(apps.list);

    const open = function(app: Apps.Application){
        app.launch()
        close()
    }

    return (
        <box orientation={Gtk.Orientation.VERTICAL} class="sidebar_appmenu_window">
            <entry 
                class="sidebar_appmenu_entry"
                onActivate={() => { appsList()[selected()].launch(); close() }}
                onChanged={({ text }) => { const list = apps.fuzzy_query(text); setAppsList(list); setSelected(0)}} 
                $={(s) => { 
                    const controller = new Gtk.EventControllerKey();

                    controller.connect("key-pressed", (_, keyval) => {
                        const s = selected();
                        if (keyval === Gdk.KEY_Down) {
                            setSelected(s + 1)
                            return true;
                        }

                        if (keyval === Gdk.KEY_Up) {
                            if (s > 0) {
                                setSelected(s - 1)
                            }
                            return true;
                        }

                        return false;
                    });

                    s.add_controller(controller);
                    createEffect(() => { 
                        if (app_visible()) { 
                            s.grab_focus()
                        }
                        else { 
                            s.text = "" 
                        }
                    }) 
                }}
            />
            <scrolledwindow vexpand hexpand 
                $={(self) => {
                    scrolled = self;
                    viewport = self.get_child() as Gtk.Viewport;
                }}
            >
                <box vexpand hexpand orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                    <For each={appsList}>
                        {(app: Apps.Application, i) => {
                            return (
                                <button 
                                    $={(self) => {
                                        buttons[i()] = self;
                                    }}
                                    onClicked={() => {open(app)}} 
                                    hexpand 
                                    halign={Gtk.Align.FILL} 
                                    class={selected(s => s == i() ? "sidebar_appmenu_button selected" : "sidebar_appmenu_button")}
                                >
                                    <box spacing={4} hexpand>
                                        <image icon_name={app.icon_name} />
                                        <label label={app.name.slice(0, 28)} hexpand halign={Gtk.Align.START}/>
                                    </box>
                                </button>
                            )
                        }}
                    </For>
                </box>
            </scrolledwindow>
        </box>
    )
}
