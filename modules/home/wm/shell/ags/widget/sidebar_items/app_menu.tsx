import { Accessor, For, createState, createEffect } from "ags";
import app from "ags/gtk4/app";
import Gtk from "gi://Gtk";
import Gdk from "gi://Gdk";
import GLib from "gi://GLib";
import Apps from "gi://AstalApps"
import { execAsync } from "ags/process";

abstract class MenuEntry {
    name: string
    command: string

    constructor(name: string, command: string){
        this.name = name;
        this.command = command;
    }

    abstract launch(): void;
}

export class Command extends MenuEntry {
    launch(){
        execAsync(this.command)
    }
}

export class Nixpkg extends MenuEntry {
    full_name: string
    version: string
    programs: string[]

    constructor(name: string, full_name: string, version: string, programs: string[]){
        super(name, "")
        this.full_name = full_name;
        this.version = version;
        this.programs = programs;
    }

    launch(){ this.install() }
    install() {
        execAsync(`notify-send "Package Info" "${this.full_name}\n${this.version}\n${this.programs[0]}"`)
    }
}

export default function AppMenu({ app_visible, close, show_app } : { app_visible: Accessor<boolean>, close: () => void, show_app: () => void }){
    const apps = new Apps.Apps({
        nameMultiplier: 2,
        entryMultiplier: 0,
        executableMultiplier: 2,
    })

    const commands = [ // TODO move to something nix configurable
        { name: "⏻ shutdown", command: "showdown now" },
        { name: "󰜉 reboot", command: "reboot" },
        { name: "󰤄 sleep", command: "systemctl suspend" },
        { name: " lock", command: "hyprlock" }, // TODO change to system default
        { name: "󰍃 logout", command: `pkill -f ${GLib.getenv("XDG_CURRENT_DESKTOP")}` },
    ];

    const [appsList, setAppsList] = createState<Apps.Application[] | Command[] | Nixpkg[]>([]);
    const [selected, setSelected] = createState<number>(0);

    let scrolled: Gtk.ScrolledWindow;
    let viewport: Gtk.Viewport;
    let buttons: Gtk.Button[] = [];
    let entry: Gtk.Entry;

    createEffect(() => {
        const index = selected(s => ((s + 1) < buttons.length) ? s + 1 : s);
        const button = buttons[index()];

        if (button) {
            viewport.scroll_to(button, null);
        }
    });

    const fuzzyMatch = (value: string, query: string) => {
        if (!query) return true

        let i = 0

        for (const char of value.toLowerCase()) {
            if (char === query[i].toLowerCase()) i++
            if (i === query.length) return true
        }

        return false
    }

    const startup = function(entry?: Gtk.Entry){
        if (entry) entry.text = "";
        setAppsList([])
        setAppsList(apps.list);
        setSelected(0);
    }; startup()

    const open = function(app: Apps.Application | Command){
        app.launch()
        close()
    }

    app.connect("request", (app, [cmd, arg, ...rest], response) => {
        if (cmd === "app_menu") {
            show_app()
            startup()
            entry.grab_focus()
            response("ok")
        }
    })

    return (
        <box orientation={Gtk.Orientation.VERTICAL} class="sidebar_appmenu_box" vexpand>
            <entry 
                class="sidebar_appmenu_entry"
                onActivate={() => { appsList()[selected()].launch(); close() }}
                onChanged={({ text }) => { 
                    // const list: Apps.Application[] | Command[] = (text.slice(0,1) == ":") ? commands : ((text.slice(0,1) == "@") ? [] : apps.fuzzy_query(text))                            
                    //         .map(command => new Command(command.name, command.command))
                    //         .filter(v => fuzzyMatch(v.name, text.slice(1)))

                    let list: Apps.Application[] | Command[] | Nixpkg[];
                    switch (text.slice(0, 1)) {
                        case ":":
                            list = commands
                                .map(command => new Command(command.name, command.command))
                                .filter(v => fuzzyMatch(v.name, text.slice(1)))
                            break

                        case "@":
                            // list = commands
                            //     .map(command => new Command(command.name, command.command))
                            //     .filter(v => fuzzyMatch(v.name, text.slice(1)))
                            if(text.length < 2) return
                            list = [];
                            execAsync(`nh search -j "${text.slice(1)}"`)
                                .then(pkgs_s => {
                                    const pkgs_json = JSON.parse(pkgs_s)["results"]
                                    for (let pkg of pkgs_json){
                                        list.push(new Nixpkg(pkg.package_pname, pkg.package_attr_name, pkg.package_pversion, pkg.package_programs))
                                    }
                                    setAppsList(list)
                                    setSelected(0)
                                })
                                .catch(e => console.log(e))
                            break;

                        default:
                            list = apps.fuzzy_query(text);
                    }

                    setAppsList(list); 
                    setSelected(0)
                }} 
                $={(s) => { 
                    entry = s;
                    const controller = new Gtk.EventControllerKey();

                    controller.connect("key-pressed", (_, keyval) => {
                        const s = selected();
                        if (keyval === Gdk.KEY_Down) {
                            if (s < appsList().length - 1){
                                setSelected(s + 1)
                            }
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
                            startup(s);

                        }
                    }) 
                }}
            />
            <scrolledwindow vexpand hexpand 
                css="padding: 0px;"
                $={(self) => {
                    scrolled = self;
                    viewport = self.get_child() as Gtk.Viewport;
                }}
            >
                <box vexpand hexpand orientation={Gtk.Orientation.VERTICAL}>
                    <For each={appsList}>
                        {(app: Apps.Application | Command, i) => {
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
                                        <image icon_name={app.icon_name ?? ""} />
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
