extends Node

var Players = {}

func GetGroundPlayerID():
    for playerID in Players:
        if Players[playerID].isGroundPlayer == true:
            return playerID

    return null