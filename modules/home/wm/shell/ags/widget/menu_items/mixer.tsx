import { createBinding, createState, For } from "ags";
import Gtk from "gi://Gtk";
import AstalWp from "gi://AstalWp"
import Pango from "gi://Pango";

import MenuBar from "../menu_bar.tsx"

export default function Mixer({ backCallback }: { backCallback: () => void }){
    const wp = AstalWp.get_default()
    const audio = wp.get_audio();

    const [streams, setStreams] = createState<AstalWp.Stream[]>([]);

    const updateStreams = function(){
        setStreams(audio.get_streams());
    }; updateStreams();

    wp.connect("ready",updateStreams);
    audio.connect("stream-added",updateStreams);
    audio.connect("stream-removed",updateStreams);
    return (
        <box vexpand={true} hexpand={true}>
            <MenuBar backCallback={backCallback} />
            <box orientation={Gtk.Orientation.HORIZONTAL} hexpand={true} vexpand={true}>
                <scrolledwindow vexpand={true} hexpand={true} class="menu_list_box">
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={4} vexpand={true}>
                        <For each={streams}>
                            {(s) => {
                                const volume = createBinding(s, "volume");
                                return (
                                    <box orientation={Gtk.Orientation.HORIZONTAL} hexpand class="menu_mixer_box">
                                        <label 
                                            class="menu_mixer_label"
                                            label={s?.name?.slice(0,30)} 
                                            valign={Gtk.Align.END} 
                                            wrap 
                                            wrapMode={Pango.WrapMode.CHAR}
                                            maxWidthChars={10}
                                        />
                                        <slider
                                            class="menu_mixer_bar"
                                            inverted
                                            hexpand
                                            orientation={Gtk.Orientation.HORIZONTAL}
                                            min={0}
                                            max={1}
                                            value={volume((v) => Number.isFinite(v) ? v : 0)}
                                            onValueChanged={(self) => {
                                                s.set_volume(self.value);
                                            }}
                                        />
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
