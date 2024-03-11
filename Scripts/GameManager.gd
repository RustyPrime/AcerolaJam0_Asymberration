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

func reset():
    var level = get_node_or_null("/root/Level")
    if level != null:
        level.queue_free()

    var mainMenu = get_node_or_null("/root/MainMenu")
    if mainMenu != null:
        mainMenu.dispose()
        mainMenu.queue_free()
    
    var preMain = get_node_or_null("/root/PreMainMenu")
    preMain.show()
    preMain.loadingLabel.hide()

    selectedMode = PlayMode.UnInit
    Players.clear()
    