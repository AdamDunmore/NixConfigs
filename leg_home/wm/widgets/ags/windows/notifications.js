const notifications = await Service.import("notifications");

const Notification_Item = (data) => {
    let image_path = "";
    if (data != undefined){
        if(data["image"]){
            image_path = data["image"]
        }
        else if(data["app-icon"]){
            image_path = data["app-icon"]
        }

        return Widget.Box({
            orientation: 0,
            className: "notification_item",
            children: [
                Widget.Icon({
                    className: "notification_image",
                    icon: image_path,
                    setup: (self) => {
                        if(!image_path){
                            self.destroy()
                        }
                    }
                }),
                Widget.Box({
                    orientation: 1,
                    vpack: "center",
                    children: [
                        Widget.Label({
                            label: `${data.summary}`,
                        }),
                        Widget.Label({
                            label: `${data.body}`
                        })
                    ]
                })
            ]
        })
    }
    else{
        return Widget.Box();
    }
}

const Notification_Box = Widget.Box({
    css: "min-width: 1px; min-height: 1px;", //Without this everything doesn't work and I have no idea why
    orientation: 1,
})

function onNotification(self, id){
    let n = notifications.getNotification(id)
    self.children = [Notification_Item(n), ...self.children];

    Utils.timeout(3000, () => {Notification_Box.children[Notification_Box.children.length - 1].destroy()})
}

Notification_Box.hook(notifications, onNotification, "notified")

const Notifications = Widget.Window({
    anchor: ["top", "right"],
    name: "notifications",
    monitor: 1,
    child: Notification_Box
})

export default Notifications;
