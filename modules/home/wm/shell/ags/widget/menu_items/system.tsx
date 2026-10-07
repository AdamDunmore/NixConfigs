import Gtk from "gi://Gtk";
import { createState } from "ags";
import { execAsync } from "ags/process";

import MenuBar from "./menu_bar.tsx";
import MenuPage from "./menu_page.tsx";

export default function System({ backCallback }: { backCallback: () => void }){
    const [ cpu, setCpu ] = createState<number>(0);
    const [ cpu_temp, setCpuTemp ] = createState<number>(0);
    const [ gpu, setGpu ] = createState<number>(0);
    const [ gpu_temp, setGpuTemp ] = createState<number>(0);
    const [ ram, setRam ] = createState<number>(0);

    const updateStats = async () => {
        try {
            const output = await execAsync(["systemstats"]);
            const outputJson = JSON.parse(output);
            setCpu(outputJson["cpu"])
            setCpuTemp(outputJson["cpu_temp"])
            setGpu(outputJson["gpu"])
            setGpuTemp(outputJson["gpu_temp"])
            setRam(outputJson["ram"])
        } catch (e) {
            print(`systemstats failed: ${e}`);
        }
    }; updateStats();
    setInterval(updateStats, 2000);

    return (
        <MenuPage>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.VERTICAL} hexpand={true}>
                <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="menu_system_box" >
                    <label class="menu_system_label" label=" CPU" />
                    <box hexpand>
                        <label class="menu_system_label" label="" css="min-width: 0px;"/>
                        <levelbar hexpand valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL} value={cpu(c => c / 100)} /> 
                        <label class="menu_system_label" label={cpu(c => `${c.toFixed(1)}%`)} />
                    </box>
                    <box hexpand>
                        <label class="menu_system_label" label="" css="min-width: 0px;"/>
                        <levelbar hexpand valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL} value={cpu_temp(c => c / 100)} /> 
                        <label class="menu_system_label" label={cpu_temp(c => `${c.toFixed(1)}°C`)} />
                    </box>
                </box>
                <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="menu_system_box" >
                    <label class="menu_system_label" label="󰢮 GPU" />
                    <box hexpand>
                        <label class="menu_system_label" label="" css="min-width: 0px;"/>
                        <levelbar hexpand valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL} value={gpu(c => c / 100)} /> 
                        <label class="menu_system_label" label={gpu(g => `${g.toFixed(1)}%`)} />
                    </box>
                    <box hexpand>
                        <label class="menu_system_label" label="" css="min-width: 0px;"/>
                        <levelbar hexpand valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL} value={gpu_temp(c => c / 100)} /> 
                        <label class="menu_system_label" label={gpu_temp(g => `${g.toFixed(1)}°C`)} />
                    </box>
                </box>
                <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="menu_system_box">
                    <label class="menu_system_label" label=" RAM" />
                    <box hexpand>
                        <label class="menu_system_label" label="" css="min-width: 0px;"/>
                        <levelbar hexpand valign={Gtk.Align.CENTER} orientation={Gtk.Orientation.HORIZONTAL} value={ram(r => r / 100)} /> 
                        <label class="menu_system_label" label={ram(r => `${r.toFixed(1)}%`)} />
                    </box>
                </box>
            </box>
        </MenuPage>
    );
}
