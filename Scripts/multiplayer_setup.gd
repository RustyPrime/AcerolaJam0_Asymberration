extends Control

@onready var console : VBoxContainer = $ColorRect/ScrollContainer/VBoxContainer
@onready var joining : Control = $Joining
@onready var hostButton : Button = $Host
@onready var startButton : Button = $Start
@onready var ipField : LineEdit = $Joining/IpToJoin
@onready var portField : LineEdit = $Joining/Port

var peer : ENetMultiplayerPeer
var prevMenu : Control

var hasOtherPlayerJoined = false
var isHosting = false

var ip_adress = "127.0.0.1"
var port = 27015
var compression : ENetConnection.CompressionMode = ENetConnection.COMPRESS_RANGE_CODER

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if OS.has_feature("windows"):
		if OS.has_environment("COMPUTERNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("x11"):
		if OS.has_environment("HOSTNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("OSX"):
		if OS.has_environment("HOSTNAME"):
			ip_adress = IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)

	portField.text = str(port)
	startButton.hide()


func _on_host_pressed():
	port = int(portField.text)

	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		debugLog("Cannot Host: " + error)
		return

	peer.get_host().compress(compression)
	multiplayer.multiplayer_peer = peer
	debugLog("Host succesful on local ip: " + ip_adress + " on Port: " + str(port))
	debugLog("Give this ip to another player in your local network.")
	debugLog("Waiting for another player!")
	SendPlayerInformation("", multiplayer.get_unique_id(), true)

	joining.hide()
	hostButton.hide()
	startButton.show()
	isHosting = true


func _on_join_pressed():
	ip_adress = ipField.text
	if ip_adress == "" or ip_adress == null:
		debugLog("Please enter a valid ip.")
		return
	port = int(portField.text)

	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip_adress, port)
	if error != OK:
		debugLog("Error: Could not join. Error Code: " + str(error))
		return
	peer.get_host().compress(compression)
	multiplayer.multiplayer_peer = peer


func _on_start_pressed():
	if hasOtherPlayerJoined:
		StartGame.rpc()
	else:
		debugLog("Cannot start yet, waiting for another player!")
	
@rpc("any_peer", "call_local")
func StartGame():
	var gameScene = preload("res://Scenes/level_1.tscn").instantiate()
	get_tree().root.add_child(gameScene)
	self.hide()

@rpc("any_peer")
func SendPlayerInformation(player_name, id, isGroundPlayer):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : player_name,
			"isGroundPlayer" : isGroundPlayer
		}
	if multiplayer.is_server():
		for identifier in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[identifier].name, identifier, GameManager.Players[identifier].isGroundPlayer)




func peer_connected(id):
	if isHosting:
		debugLog("A player has connected with id: " + str(id))
		debugLog("As the host you can now start the game.")
	hasOtherPlayerJoined = true
	
func peer_disconnected(id):
	debugLog("A player has disconnected with id: " + str(id))
	hasOtherPlayerJoined = false
	
func connected_to_server():
	debugLog("Successfully connected to host!")
	SendPlayerInformation.rpc_id(1, "", multiplayer.get_unique_id(), false)
	

	hostButton.hide()
	startButton.hide()
	joining.hide()
	debugLog("Join successful, waiting for the host to start the game...")



func connection_failed():
	debugLog("Connection to host failed.")
	

func debugLog(text):
	var label = Label.new()
	label.text = str(text)
	console.add_child(label)



func _on_back_pressed():
	dispose()
	GameManager.reset()

func dispose():
	multiplayer.peer_connected.disconnect(peer_connected)
	multiplayer.peer_disconnected.disconnect(peer_disconnected)
	multiplayer.connected_to_server.disconnect(connected_to_server)
	multiplayer.connection_failed.disconnect(connection_failed)

	if peer != null:
		peer.close()