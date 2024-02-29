extends Node3D

var peer = ENetMultiplayerPeer.new()

@export var player1_scene : PackedScene
@export var player2_scene : PackedScene


func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_spawn_remote_player)
	spawn_player()

func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer
	


func _on_offline_pressed():
	pass # Replace with function body.



func spawn_player(id = 1):
	var player1 = player1_scene.instantiate()
	player1.name = "player" + str(id)
	get_parent().add_child(player1)


func _spawn_remote_player(id):
	var player2 = player2_scene.instantiate()
	player2.name = "player" + str(id)
	get_parent().add_child(player2)
