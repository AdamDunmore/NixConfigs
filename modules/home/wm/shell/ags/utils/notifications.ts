import { execAsync } from "ags/process";

export class NotificationAction {
    name: string
    title: string

    constructor(name: string, title: string) { this.name = name, this.title = title; }
}

export async function SendNotification(title: string, description: string, actions?: NotificationAction[]){
    const actions_cmd: string[] = actions ? actions.map(action => `${action.name}=${action.title}`).flatMap(x => ["-A", x]) : [];
    return await execAsync([
        "notify-send",
        title,
        description,
    ].concat(actions_cmd))
}
