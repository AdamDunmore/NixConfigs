import bluetooth from '../services/bluetooth.js'

const Bluetooth_Entry = (data) => {
    return Widget.Box({
        child: Widget.Label({
            label: data.name
        })
    })
}

const Bluetooth_Scanning_Toggle = Widget.Box({
    child: Widget.Button({
        label: bluetooth.bind('scanning').as(v => `${v}`),
        on_clicked: () => {
            bluetooth.toggleScanning()
        }
    })
})

const Bluetooth = Widget.Window({
    name: "bluetooth_menu",
    css: "background-color: red; min-width: 1px; min-height: 1px;",
    child: Widget.Box({
        children: [
            Bluetooth_Scanning_Toggle
        ],
        setup: self => {
            bluetooth.connect('available-devices-changed', data => {
                let children = [];
                let devices = data["available-devices"]
                console.log(data)
                for (let x = 0; x < devices.length; x++){
                    children.push(Bluetooth_Entry(devices[x]))
                }
                children.push(Bluetooth_Scanning_Toggle)
                self.children = children;
            })
            
        }
    })
})

export default Bluetooth;
