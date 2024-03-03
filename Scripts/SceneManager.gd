extends Node3D


@export var player1_scene : PackedScene
@export var player1_remote_scene : PackedScene
@export var player2_scene : PackedScene

@export var player1_spawnPoint : Node3D
@export var player2_spawnPoint : Node3D

var playerID = -1


func _ready():
	for id in GameManager.Players:
		if id == multiplayer.get_unique_id():
			if GameManager.Players[id].isGroundPlayer == true:
				spawn_player("player1", player1_scene, player1_spawnPoint)
				playerID = id
				#$WorldEnvironment/WorldEnvironment/DirectionalLight3D.
			else:
				var player2 = spawn_player("player2", player2_scene, player2_spawnPoint)
				# spawn remote player 1
				var remotePlayer1 = spawn_player("player1", player1_remote_scene, player1_spawnPoint)
				player2.remotePlayer1 = remotePlayer1.get_node("Player1")
				# make ceiling invisible
				$World/Ceiling.queue_free()


func spawn_player(player_name, player_scene, player_spawn : Node3D):
	var player = player_scene.instantiate()
	player.name = player_name
	add_child(player)
	player.global_position = player_spawn.position
	return player
	
	
@rpc("any_peer", "call_local")
func spawn_unit(unitDataJSON):
	var unitData = UnitData.FromJSON(unitDataJSON)
	var spawned_unit = load(unitData.path).instantiate()
	add_child(spawned_unit)
	spawned_unit.global_position = unitData.spawn_position
	spawned_unit.name = unitData.name
	if playerID != -1:
		spawned_unit.SetAuthoritiy(playerID)