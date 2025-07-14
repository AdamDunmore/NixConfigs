import Mpris from "gi://AstalMpris";

export default class UMpris {
    mpris: Mpris.Mpris; 
    players: Mpris.Player[]; 

    constructor(){
        this.mpris = new Mpris.Mpris();
        this.players = this.mpris.players;
    }

    updatePlayers() : void {
        this.players = this.mpris.players;
    }

    getPlayerNames() : String[] {
        const names : String[] = [];
        for(let x = 0; x < this.players.length; x++) {
            names.push(this.players[x].get_identity())
        }
        return names; 
    }
}
