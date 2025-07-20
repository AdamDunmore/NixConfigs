import Mpris from "gi://AstalMpris";

const mpris = Mpris.Mpris;

export default class UMpris {
    static getPlayerNames() : String[] {
        const players = mpris.get_players();
        const names : String[] = [];
        for(let x = 0; x < players.length; x++) {
            names.push(players[x].get_identity())
        }
        return names; 
    }

    static getPlayers(){
        return mpris.players;
    }
}
