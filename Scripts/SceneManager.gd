extends Node3D


@export var player1_scene : PackedScene
@export var player1_remote_scene : PackedScene
@export var player2_scene : PackedScene

@onready var player1_spawnPoint = $Multiplayer/SpawnPoint1
@onready var player2_spawnPoint = $Multiplayer/SpawnPoint2

func _ready():
	for id in GameManager.Players:
		if id == multiplayer.get_unique_id():
			if GameManager.Players[id].is_fps == true:
				spawn_player("player1", player1_scene, player1_spawnPoint)
			else:
				spawn_player("player2", player2_scene, player2_spawnPoint)
				# spawn remote player 1
				spawn_player("player1", player1_remote_scene, player1_spawnPoint)


func spawn_player(player_name, player_scene, player_spawn):
	var player = player_scene.instantiate()
	player.name = player_name
	add_child(player)
	player.global_position = player_spawn.global_position
	
	
