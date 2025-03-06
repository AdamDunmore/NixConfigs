function getRam(){
    let ram_unformated = Utils.exec("/home/adam/.config/ags/scripts/ram.sh")
    ram.set_label(`    ${Math.floor(Number(ram_unformated))}%`);
}

function getCPU(){
    let cpu_unformated = Utils.exec("/home/adam/.config/ags/scripts/cpu.sh")
    cpu.set_label(`    ${Math.floor(Number(cpu_unformated))}%`)
}

const cpu = Widget.Label({className: "device_info"})
const ram = Widget.Label({className: "device_info"})

const device_info = Widget.Box({
    children: [
        cpu,
        ram,
    ]
})

Utils.interval(1000, getRam)
Utils.interval(1000, getCPU)

export default device_info
