const Power_Warning = function(operation){
    return Widget.Window({
        name: `power_warning:${operation.slice(0,2)}`,
        monitor: 1,
        className: "power_warning_menu",
        child: Widget.Box({
            className: "power_warning_container",
            orientation: 1,
            children: [
                Widget.Label({
                    className: "power_warning_text",
                    label: "Are you sure?"
                }),
                Widget.Box({
                    children: [
                        Widget.Button({
                            className: "power_warning_button",
                            label: 'Cancel',
                            on_clicked: (s) => {s.parent.parent.parent.hide(); Utils.execAsync("ags -t 'menu'");}  
                        }),
                        Widget.Button({
                            className: "power_warning_button",
                            label: 'Confirm',
                            on_clicked: (s) => {s.parent.parent.parent.hide(); Utils.exec(operation)}
                        })
                    ]
                })
            ]
        })
    })
}

export default Power_Warning;
