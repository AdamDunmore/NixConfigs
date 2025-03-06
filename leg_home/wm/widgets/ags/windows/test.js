const TestSwitch = Widget.Switch({
    css: "min-width: 200px; min-height: 200px; background-color: #0000ff",
})

const TestWindow = Widget.Window({
    name: "test_window",
    keymode: "exclusive",
    layer: "top",
    css: "min-width: 200px; min-height: 200px; background-color: #ff0000",
    child: TestSwitch,
});

TestWindow.connect("key_press_event", (s, t) => {
    let keyval = t.get_keyval()[1];
    console.log(keyval);
    if (keyval == 65307){ //If key is escape then close
        TestWindow.destroy();
    }
    if (keyval == 65515){
        TestSwitch.activate()
    }
    return true;
})


export default TestWindow

//Tab key is 65289
