extends Control

@onready var loadingLabel : Label = $LoadingLabel

func _ready():
	loadingLabel.hide()

func _on_lan_pressed():
	if OS.get_name() == "Web":
		return
	GameManager.selectedMode = GameManager.PlayMode.LAN
	var gameScene = preload("res://Scenes/main_menu.tscn").instantiate()
	gameScene.prevMenu = self
	get_tree().root.add_child(gameScene)
	self.hide()


func _on_singleplayer_pressed():
	loadingLabel.show()
	GameManager.selectedMode = GameManager.PlayMode.Singleplayer
	var gameScene = preload("res://Scenes/level_1.tscn").instantiate()
	get_tree().root.add_child(gameScene)
	self.hide()



func _on_exit_pressed():
	if OS.get_name() == "Web":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		get_tree().quit()
