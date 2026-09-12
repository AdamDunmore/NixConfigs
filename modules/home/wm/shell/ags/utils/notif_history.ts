import { createState } from "ags";

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
