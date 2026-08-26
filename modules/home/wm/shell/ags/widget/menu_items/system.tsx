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
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} vexpand={true}>
                <label class="system_label" label={stats(s => `CPU: ${s.cpu.toFixed(1)}%`)} />
                <label class="system_label" label={stats(s => `CPU Temp: ${s.cpu_temp.toFixed(1)}°C`)} />
                <label class="system_label" label={stats(s => `GPU: ${s.gpu.toFixed(1)}%`)} />
                <label class="system_label" label={stats(s => `GPU Temp: ${s.gpu_temp.toFixed(1)}°C`)} />
                <label class="system_label" label={stats(s => `RAM: ${s.ram.toFixed(1)}%`)} />
            </box>
        </box>
    );
}
