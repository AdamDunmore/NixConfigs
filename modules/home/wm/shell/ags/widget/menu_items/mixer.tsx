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
                <scrolledwindow vexpand={true} hexpand={true}>
                    <box orientation={Gtk.Orientation.HORIZONTAL} spacing={4} vexpand={true}>
                        <For each={streams}>
                            {(s) => {
                                const volume = createBinding(s, "volume");
                                return (
                                    <box orientation={Gtk.Orientation.VERTICAL} vexpand={true} class="menu_mixer_bar">
                                        <slider
                                            inverted
                                            vexpand={true}
                                            orientation={Gtk.Orientation.VERTICAL}
                                            min={0}
                                            max={1}
                                            value={volume((v) => Number.isFinite(v) ? v : 0)}
                                            onValueChanged={(self) => {
                                                s.set_volume(self.value);
                                            }}
                                        />
                                        <label 
                                            class="mixer_label"
                                            label={s?.name?.slice(0,30)} 
                                            valign={Gtk.Align.END} 
                                            wrap 
                                            wrapMode={Pango.WrapMode.WORD_CHAR}
                                            maxWidthChars={10}
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
