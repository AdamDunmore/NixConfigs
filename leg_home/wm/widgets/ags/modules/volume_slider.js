const audio = await Service.import("audio");

const Volume = Widget.Box({
    vexpand: true,
    hexpand: true,
    orientation: 0,
    children: [
        Widget.Label({label: ""}),
        Widget.Slider({
            className: "volume_scale",
            draw_value: false,
            hexpand: true,
            vexpand: true,
            on_change: ({ value }) => audio.speaker.volume = value,
            setup: self => self.hook(audio.speaker, () => {
                self.value = audio.speaker.volume || 0
            }),
        })
    ]
})

const VolumeSlider = Widget.Box({
    className: "volume_slider",
    orientation: 1,
    hexpand: true,
    vexpand: true,
    children: [
        Volume,
    ]
})

export default VolumeSlider;
