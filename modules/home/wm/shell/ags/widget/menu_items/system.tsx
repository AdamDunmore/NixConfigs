import Gtk from "gi://Gtk";
import { createState } from "ags";
import { execAsync } from "ags/process";
import GLib from "gi://GLib";

import MenuBar from "./menu_bar.tsx";
import MenuPage from "./menu_page.tsx";

export default function System({ backCallback }: { backCallback: () => void }){
    const [ osName, setOsName ] = createState<string>("");
    const [ kernelVersion, setKernelVersion ] = createState<string>("");
    const [ host, setHost ] = createState<string>("");
    const [ uptime, setUptime ] = createState<string>("");
    const [ cpu, setCpu ] = createState<number>(0);
    const [ cpu_temp, setCpuTemp ] = createState<number>(0);
    const [ gpu, setGpu ] = createState<number>(0);
    const [ gpu_temp, setGpuTemp ] = createState<number>(0);
    const [ ram, setRam ] = createState<number>(0);

    const [ok, contents] = GLib.file_get_contents("/etc/os-release");

    if (ok) {
        const osRelease = new TextDecoder().decode(contents);
        setOsName(`${osRelease.match(/^PRETTY_NAME="?([^"\n]*)"?$/m)?.[1]}`);
    }

    execAsync("uname -r").then(o => setKernelVersion("Linux " + o))

    execAsync([
        "cat",
        "/sys/devices/virtual/dmi/id/product_name",
    ]).then(o => setHost(o.trim()));

    const updateStats = async () => {
        try {
            const output = await execAsync(["systemstats"]);
            const outputJson = JSON.parse(output);
            execAsync(["sh", "-c", "uptime | awk '{print $1}'"]).then(o => setUptime("Uptime: " + o))
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
                <box orientation={Gtk.Orientation.VERTICAL} hexpand={true} class="menu_system_box">
                    <label class="menu_system_label" label={osName} />
                    <label class="menu_system_label" label={kernelVersion} />
                    <label class="menu_system_label" label={host} />
                    <label class="menu_system_label" label={uptime} />
                </box>
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
