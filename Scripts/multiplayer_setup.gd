extends Control

var peer : ENetMultiplayerPeer


var address = "localhost"
var port = 8910
var compression : ENetConnection.CompressionMode = ENetConnection.COMPRESS_RANGE_CODER

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		#print("Cannot Host: " + error)
		return

	peer.get_host().compress(compression)
	multiplayer.multiplayer_peer = peer
	#print("Waiting for players!")
	SendPlayerInformation($Username.text, multiplayer.get_unique_id(), true)


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(compression)
	multiplayer.multiplayer_peer = peer

func _on_start_pressed():
	StartGame.rpc()
	

func _on_offline_pressed():
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func StartGame():
	var gameScene = load("res://Scenes/level_1.tscn").instantiate()
	get_tree().root.add_child(gameScene)
	self.hide()

@rpc("any_peer")
func SendPlayerInformation(player_name, id, isGroundPlayer):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : player_name,
			"isGroundPlayer" : isGroundPlayer
			# todo: add score?
		}
	if multiplayer.is_server():
		for identifier in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[identifier].name, identifier, GameManager.Players[identifier].isGroundPlayer)




func peer_connected(id):
	#print("player connected" + str(id))
	pass
func peer_disconnected(id):
	#print("player disconnected" + str(id))
	pass
func connected_to_server():
	#print("connected to server")
	SendPlayerInformation.rpc_id(1, $Username.text, multiplayer.get_unique_id(), false)

func connection_failed():
	#print("connection failed")
	pass