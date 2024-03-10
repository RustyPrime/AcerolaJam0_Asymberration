extends Node


enum PlayMode {
    UnInit,
    LAN,
    Singleplayer
}

var selectedMode : PlayMode = PlayMode.UnInit

var Players = {}

func GetGroundPlayerID():
    for playerID in Players:
        if Players[playerID].isGroundPlayer == true:
            return playerID

    return null


func isLAN():
    return selectedMode == PlayMode.LAN