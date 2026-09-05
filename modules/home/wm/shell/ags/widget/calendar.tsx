import { Gtk } from "ags/gtk4";
import Pango from "gi://Pango";
import { execAsync } from "ags/process";
import { createState, For } from "ags";

export enum EventMonth {
    January,
    Febuary,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December
}

export class EventDate {
    day: number
    month: EventMonth
    year: number

    constructor(day: number, month: EventMonth, year: number)
    constructor(date: string)
    constructor(day_or_date: number | string, month?: EventMonth, year?: number) {
        if (typeof day_or_date === "number" && month && year) {
            this.day = day_or_date;
            this.month = month;
            this.year = year;
            return
        }
        else if (typeof day_or_date === "string") {
            const date_arr = day_or_date.split("-");
            this.day = Number(date_arr[2]);
            this.month = Number(date_arr[1]) as EventMonth;
            this.year = Number(date_arr[0]);
            return
        }
        this.day = -1;
        this.month = EventMonth.January;
        this.year = -1;
    }

    public toStr(){
        return `${this.day}/${this.month}/${this.year}`;
    }

    public isValid(){
        return (this.day > -1 && this.year > -1);
    }

    public isToday(){
        const today = new Date();
        return (
            this.day == today.getDate() &&
            (Number(this.month) - 1) == today.getMonth() &&
            this.year == today.getFullYear()
        )
    }
}

export class EventTime {
    minutes: number
    hours: number

    constructor(time: string)
    constructor(minutes: number, hours: number)
    constructor(minutes_or_time: number | string, hours?: number){
        if (typeof minutes_or_time === "number" && hours){
            this.minutes = minutes_or_time;
            this.hours = hours; 
            return
        } else if (typeof minutes_or_time === "string") {
            const time_arr: string[] = minutes_or_time.split(':');
            if (time_arr.length > 1) {
                this.minutes = Number(time_arr[1])
                this.hours = Number(time_arr[0])
                return
            }
        }
        this.minutes = -1;
        this.hours = -1;
    }

    public toStr(){
        return `${this.hours.toString().padStart(2, "0")}:${this.minutes.toString().padStart(2, "0")}`;
    }

    public isValid(){
        return (this.hours > -1 && this.minutes > -1);
    }
}

export class Event {
    title: string
    start_date: EventDate
    end_date: EventDate
    start_time?: EventTime
    end_time?: EventTime

    constructor(title: string, start_date: EventDate, end_date: EventDate, start_time?: EventTime, end_time?: EventTime){
       this.title = title; 
       this.start_date = start_date;
       this.end_date = end_date;
       this.start_time = start_time;
       this.end_time = end_time;
    }
}

const [ events, setEvents ] = createState<Event[]>([]);

const getEvents = function(){
    const start = new Date();
    start.setDate(start.getDate() - 2);
    const end = new Date(start);
    end.setMonth(end.getMonth() + 1);
    const formatDate = (date: Date) =>
        `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;

    execAsync(`gcalcli agenda --tsv "${formatDate(start)}" "${formatDate(end)}"`)
        .then(v => { 
            const events: Event[] = v
                .trim()
                .split('\n')
                .map(row => row.split('\t'))
                .slice(1)
                .map(event => {
                    return new Event(event[4], new EventDate(event[2]), new EventDate(event[0]), new EventTime(event[1]), new EventTime(event[3]))
                })

            setEvents(events)
        })
        .catch(_ => { setEvents([]) })  
}; getEvents()

export default function Calendar(){

    return (
        <box halign={Gtk.Align.END} class="menu menu_calendar_box" spacing={5}>
            <box valign={Gtk.Align.START} halign={Gtk.Align.END}>
                <button class="menu_button" label="" onClicked={getEvents}/>
            </box>
            <box orientation={Gtk.Orientation.VERTICAL} class="menu_calendar_container">
                <label visible={events(e => e.length > 0 ? false : true)} label={"No connected to Google Calendar \n Please authenticate gcalcli"} /> 
                <scrolledwindow>
                    <box class="menu_list_box" orientation={Gtk.Orientation.VERTICAL} vexpand>
                        <For each={events}>
                            { (event: Event) => {
                                return (
                                    <box hexpand orientation={Gtk.Orientation.VERTICAL} class={`menu_calendar_event ${event.start_date.isToday() ? "selected" : "" }`}>
                                        <box hexpand>
                                            <label label={`${event.start_date.isToday() ? "󰃶 " : ""} ${event.title}`} wrap wrapMode={Pango.WrapMode.WORD_CHAR} maxWidthChars={25}/>
                                        </box>
                                        <box hexpand>
                                            <label visible={(event.start_date.isValid() && event.end_date.isValid())} label={`${event.start_date.toStr()}${(event.start_date.toStr() != event.end_date.toStr()) ? ` - ${event.end_date.toStr()}` : ""}`} />
                                            <box hexpand />
                                            <label halign={Gtk.Align.END} visible={(event.start_time?.isValid() && event.end_time?.isValid())} label={`${event.start_time?.toStr()}-${event.end_time?.toStr()}`} />
                                        </box>
                                    </box>
                                )
                            }}
                        </For>
                    </box>
                </scrolledwindow>
            </box>
        </box>
    )
}
