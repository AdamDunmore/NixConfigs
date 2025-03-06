// Code heavily inspired by https://github.com/Aylur/ags/blob/main/example/applauncher/applauncher.js
const applications = await Service.import("applications")

let active = 0;
let oldActive;

const App_Entry = app => Widget.Button({
    child: Widget.Box({
        spacing: 10,
        children: [
            Widget.Icon({
                className: "app_menu_entry_icon",
                icon: app.icon_name
            }),
            Widget.Label({
                className: "app_menu_entry_text",
                label: app.name
            })
        ]
    }),
    className: "app_menu_entry",
    on_clicked: () => {
        App_Launcher.hide()
        app.launch()
    },
    attribute: { app },
})

let apps = applications.query("").map(App_Entry)

const App_Input = Widget.Entry({
    className: "app_menu_input",
    hexpand: true,
    on_change: ({ text }) => apps.forEach(item => {
        item.visible = item.attribute.app.match(text ?? "")
        
        active = 0
        setActive()
    }),
})

const App_Scrollable = Widget.Scrollable({
    vexpand: true,
    hscroll: "never",
    vscroll: "external",
    child: Widget.Box({
        orientation: 1,
        children: apps
    }),
})

const App_Launcher = Widget.Window({
    name: "app_launcher",
    layer: "top",
    monitor: 1,
    keymode: "exclusive",
    child: Widget.Box({
        className: "app_menu_container",
        orientation: 1,
        children: [
            Widget.Box({
                spacing: 20,
                children: [
                    Widget.Label({
                        css: "font-size: 26px;",
                        label: ""
                    }),
                    App_Input
                ]
            }),
            App_Scrollable
        ]
    })
})

App_Launcher.connect("key_press_event", (s, t) => {
    let keyval = t.get_keyval()[1];
    if (keyval == 65307){ //If key is escape then close
        close()
    }
    else if (keyval == 65362){ //Up arrow key
        setActive("-")
        let adj = App_Scrollable.get_vadjustment()
    } 
    else if (keyval == 65364){ //Down Arrow Key
        setActive("+")
    }
    else if (keyval == 65293){ //Enter key
        const results = apps.filter((item) => item.visible);
        results[active].attribute.app.launch();
        close()
    } 
    else{
        return false;
    }
    return true;
})

function close(){
    App_Launcher.hide()
    App_Input.set_text("")
}

function setActive(state){
    const results = apps.filter((item) => item.visible);
    let adj = App_Scrollable.get_vadjustment()

    if(oldActive){
        oldActive.class_name = "app_menu_entry"    
    }

    if (state == "+"){
        active += 1
        adj.set_value(adj.get_value() + 56)
    }
    else if (state == "-" && active > 0){
        active -= 1
        adj.set_value(adj.get_value() - 56)
    }
    if (active > results.length){
        active = 0;
        adj.set_value(0)
    }

    results[active].class_name = "app_menu_entry active"
    oldActive = results[active]
    App_Input.grab_focus()
}setActive()

export default App_Launcher
