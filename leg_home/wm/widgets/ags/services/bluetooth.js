//TODO: Add toggleable scanning 

class BluetoothService extends Service{

    static{ 
        Service.register(
            this,
            { //Signals
                'available-devices-changed' : ['jsobject'],
                'state-changed': ['boolean'],
                'scanning-changed' : ['boolean'],
            },
            { //Properties
                'available-devices' : ['jsobject', 'r'],
                'state' : ['boolean', 'rw'],
                'scanning' : ['boolean', 'rw'],
            }
        )
    }

    #available_devices = [];
    #state = false;
    #scanning = false;

    get available_devices() {
        return this.#available_devices;
    }

    get state(){
        return this.#state;
    }

    get scanning(){
        return this.#scanning
    }

    set state(s){
        this.#state = s;
        //Set BT
        if(s){
            Utils.execAsync("rfkill unblock bluetooth")
        }
        else{
            Utils.execAsync("rfkill block bluetooth")
        }
        this.emit('changed')
        this.notify('state')
        this.emit('state-changed', this.#state)
    }

    set scanning(s){
        this.#scanning = s;
    }

    toggleBluetooth(){
        this.#state = !this.#state;
        Utils.execAsync("rfkill toggle bluetooth")
    }

    toggleScanning(){
        this.#scanning = !this.#scanning;
        this.emit('changed')
        this.notify('scanning')
        this.emit('scanning-changed', this.#state)
    }

    constructor() {
        super();
         
        Utils.interval(6000, () => {
            if(this.#state && this.#scanning){
                this.#onDeviceChange()
                this.#available_devices = []
            }
        })
        Utils.interval(1000, () => this.#onStateChange())
    }

    #onStateChange() {
        Utils.execAsync("rfkill -J")
            .then(data => {
                const output = JSON.parse(data)
                if(output.rfkilldevices[0].soft == "blocked"){
                    this.state = false;
                }
                else{
                    this.state = true;
                }
                this.emit('changed')
                this.notify('state')
                this.emit('state-changed', this.#state)
            }) 
    }

    #onDeviceChange() {
        let _ = Utils.execAsync("bluetoothctl --timeout 5s scan on")
            .then(d => {
                const devices = d.split('\n')
                let device_arr = new Array()
                
                for (let x = 4; x < devices.length; x++){
                    let device = {}
                    let scrap_found = false;
                    let type_found = false;
                    let id_found = false;
                    let word = "";
                    for(let y = 0; y < devices[x].length; y++){
                        if (devices[x][y] == " " && !scrap_found){
                            scrap_found = true;
                            word = ""
                        }
                        else if(devices[x][y] == " " && scrap_found && !type_found){
                            device.type = word; 
                            type_found = true;
                            word = "";
                        }
                        else if(devices[x][y] == " " && scrap_found && type_found && !id_found){
                            device.id = word;
                            id_found = true;
                            word = "";
                        }
                        else{
                            word += devices[x][y]
                        }
                        if(type_found && id_found && y == devices[x].length - 1){
                            let newWord = "";
                            let colonFound = false;
                            let z = 0;
                            while(!colonFound && z < word.length){
                                if(word[z] != ":"){
                                    newWord += word[z]
                                }
                                else{
                                    colonFound = true;
                                }
                                z++
                            }
                            device.name = newWord   
                        }
                    }
                    device_arr.push(device)
                }
                
                if (device_arr != this.#available_devices){
                    this.#available_devices = device_arr;
                    
                    this.emit('changed')
                    this.notify('available-devices')
                    this.emit('available-devices-changed', this.#available_devices)
                }
            })
        .catch(err => console.log(`Error: ${err}`))
    }

    connect(event = 'available-devices-changed', callback) {
        return super.connect(event, callback);
    }
}

const service = new BluetoothService;

export default service;
