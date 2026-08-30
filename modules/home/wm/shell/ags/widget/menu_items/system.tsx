import Gtk from "gi://Gtk";
import { createState } from "ags";
import { execAsync } from "ags/process";

import MenuBar from "../menu_bar.tsx";

export default function System({ backCallback }: { backCallback: () => void }){
    const [stats, setStats] = createState({
        cpu: 0,
        ram: 0,
        cpu_temp: 0,
        gpu: 0,
        gpu_temp: 0,
    });

    const updateStats = async () => {
        try {
            const output = await execAsync(["systemstats"]);
            setStats(JSON.parse(output));
        } catch (e) {
            print(`systemstats failed: ${e}`);
        }
    }; updateStats();
    setInterval(updateStats, 2000);

    return (
        <box vexpand={true} hexpand={true}>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} >
                <box orientation={Gtk.Orientation.HORIZONTAL}>
                    <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="system_box" >
                        <label class="system_label" label=" CPU" />
                        <label class="system_label" label={stats(s => ` ${s.cpu.toFixed(1)}%`)} />
                        <label class="system_label" label={stats(s => ` ${s.cpu_temp.toFixed(1)}°C`)} />
                    </box>
                    <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="system_box">
                        <label class="system_label" label="󰢮 GPU" />
                        <label class="system_label" label={stats(s => ` ${s.gpu.toFixed(1)}%`)} />
                        <label class="system_label" label={stats(s => ` ${s.gpu_temp.toFixed(1)}°C`)} />
                    </box>
                </box>
                <label class="system_label system_box" label={stats(s => ` ${s.ram.toFixed(1)}%`)} vexpand={true}/>
            </box>
        </box>
    );
}
