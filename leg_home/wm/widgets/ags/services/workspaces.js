class WorkspaceService extends Service {
    static {
        Service.register(
            this,
            { //Signals
                'workspace-changed' : ['string'],
                'workspace-data-changed' : ['jsobject']
            },
            { //Properties
                'workspace-active' : ['string', 'r'],
                'workspace-data' : ['jsobject', 'r']
            }
        );
    }
    
    #workspace_active = "0";
    #workspace_data = {};

    #old_output = "";
    #wm = "";
    #wm_workspace_command = "";

    get workspace_active(){
        return this.#workspace_active;
    }

    set workspace_active(new_workspace){
        Utils.execAsync(this.#wm_workspace_command + `${new_workspace}`)
            .then(function(){
                this.#workspace_active = new_workspace;
            })
    }

    get workspace_data(){
        return this.#workspace_data; 
    }

    constructor() {
        super();
        
        this.#wm = Utils.exec(`${Utils.HOME}/.config/ags/scripts/getwm.sh`)
        
        switch(this.#wm){
            case "sway":
                this.#wm_workspace_command = "sway workspace ";
            case ".Hyprland-wrapp":
                this.#wm_workspace_command = "hyprctl dispatch workspace ";
            default:
                break;
        }

        //Monitor
        Utils.interval(150, () => this.#updateWorkspace())
    }

    #updateWorkspace() {
        let active;
        let data;
        switch(this.#wm){
            // case "river":
            //     break;
            case "sway": 
                const output_raw_sway = Utils.exec("swaymsg -t get_workspaces -r")
                if(output_raw_sway != this.#old_output){
                    this.#old_output = output_raw_sway
                
                    try {
                        data = JSON.parse(output_raw_sway) 

                        //Find active workspace
                        for (let x = 0; x < data.length; x++){
                            if (data[x]["focused"] == true){
                                active = data[x]["name"]
                                x = data.length;
                            }
                        }

                        this.#workspace_active = active
                        this.#workspace_data = data
                    } catch (e){
                        console.log("Error: " + e)
                    }
                }

            case ".Hyprland-wrapp": //Hyprland
                const output_raw_hyprland = Utils.exec("hyprctl workspaces -j")
                if(output_raw_hyprland != this.#old_output){
                    this.#old_output = output_raw_hyprland

                    try {
                        data = JSON.parse(output_raw_hyprland)
                        
                        //Find active workspace
                        const output_active_hyprland = Utils.exec("hyprctl activeworkspace -j")
                        active = JSON.parse(output_active_hyprland)["name"]

                        this.#workspace_active = active;
                        this.#workspace_data = data;
                    } catch(e){
                        console.log("Error: " + e)
                    }
                }

            default:
                active = "Error"
                data = {}
                break;
                
        }
        
        this.emit('changed')
        this.notify('workspace-data')
        this.emit('workspace-data-changed', this.#workspace_data)
    }

    connect(event = 'workspace-changed', callback){
        return super.connect(event, callback);
    }
}

const service = new WorkspaceService;

export default service;
