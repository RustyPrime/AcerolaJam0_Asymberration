extends Node3D


@export var player1_scene : PackedScene
@export var player1_remote_scene : PackedScene
@export var player2_scene : PackedScene

@export var player1_spawnPoint : Node3D
@export var player2_spawnPoint : Node3D

@onready var multiplayerSpawner : MultiplayerSpawner = $MultiplayerSpawner
@onready var enemySpawn : Node3D = $EnemySpawn

var playerID = -1
var player1

var enemyID = 1
var enemies = {}

func _ready():
	
	multiplayerSpawner.spawn_function = spawn_enemy_function
	multiplayerSpawner.spawned.connect(_on_authority_spawned_enemy)
	
	for id in GameManager.Players:
		if id == multiplayer.get_unique_id():
			if GameManager.Players[id].isGroundPlayer == true:
				player1 = spawn_player("player1", player1_scene, player1_spawnPoint)
				playerID = id
				multiplayerSpawner.set_multiplayer_authority(id)
				#$WorldEnvironment/WorldEnvironment/DirectionalLight3D.
			else:
				var player2 = spawn_player("player2", player2_scene, player2_spawnPoint)
				# spawn remote player 1
				var remotePlayer1 = spawn_player("player1", player1_remote_scene, player1_spawnPoint)
				player2.remotePlayer1 = remotePlayer1.get_node("Player1")
				# make ceiling invisible
				%World/Ceiling.queue_free()
				
				


func spawn_player(player_name, player_scene, player_spawn : Node3D):
	var player = player_scene.instantiate()
	player.name = player_name
	add_child(player)
	player.global_position = player_spawn.global_position
	return player
	
# Gets called by ground player on behalf of player2
func spawn_enemy_via_mp_spawner(enemyDataJSON):	
	var spawned_enemy = multiplayerSpawner.spawn(enemyDataJSON)
	var enemyData = EnemyData.FromJSON(enemyDataJSON)
	setup_enemy(spawned_enemy, enemyData)
	
# Gets called on every client to spawn an enemy
func spawn_enemy_function(enemyDataJSON):
	var enemyData = EnemyData.FromJSON(enemyDataJSON)
	var spawned_enemy = load(enemyData.path).instantiate()

	enemies[str(enemyID)] = {"enemy": spawned_enemy, "data": enemyData}
	enemyID += 1

	
	return spawned_enemy

# Gets called after the spawn_function has run
# At this point the node has been added and _ready has run
func _on_authority_spawned_enemy(node : Node):
	print(multiplayer.get_unique_id())
	var enemiesCopy = enemies.duplicate(true)
	for index in enemiesCopy:
		if enemiesCopy[str(index)].enemy == node:
			setup_enemy(enemiesCopy[str(index)].enemy, enemiesCopy[str(index)].data)
	

func setup_enemy(spawned_enemy, enemyData):
	spawned_enemy.global_position = enemyData.spawn_position
	spawned_enemy.SetHealth(enemyData.power)

	if playerID != -1:
		spawned_enemy.SetPlayer(player1)
		spawned_enemy.SetAuthoritiy(playerID)
	
	var enemyIndex = -1
	for index in enemies:
		if enemies[str(index)].enemy == spawned_enemy:
			enemyIndex = index
			break

	enemies.erase(str(enemyIndex))


@rpc("any_peer", "call_remote")
func ask_player1_to_spawn_enemy(enemyData):
	if multiplayer.get_unique_id() == GameManager.GetGroundPlayerID():
		spawn_enemy_via_mp_spawner(enemyData)

