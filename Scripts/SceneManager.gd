extends Node3D
class_name SceneManager

@export var player1_scene : PackedScene
@export var player1_remote_scene : PackedScene
@export var player2_scene : PackedScene

@export var player1_spawnPoint : Node3D
@export var player2_spawnPoint : Node3D

@export var enemySpawnPoints : Array[Node3D]

@onready var multiplayerSpawner : MultiplayerSpawner = $MultiplayerSpawner
@onready var enemySpawn : Node3D = $EnemySpawns
@onready var tier1timer : Timer = $AutoSpawner/Tier1EnemyTimer
@onready var tier2timer : Timer = $AutoSpawner/Tier2EnemyTimer
@onready var tier3timer : Timer = $AutoSpawner/Tier3EnemyTimer
@onready var tier4timer : Timer = $AutoSpawner/Tier4EnemyTimer
@onready var rng = RandomNumberGenerator.new()
@onready var winScreen : Control = $GameEndUI/WinScreen
@onready var loseScreen : Control = $GameEndUI/LoseScreen

@onready var preLoadEnemy1 = preload("res://Scenes/Subscenes/Enemy1.tscn")
@onready var preLoadEnemy2 = preload("res://Scenes/Subscenes/Enemy2.tscn")
@onready var preLoadEnemy3 = preload("res://Scenes/Subscenes/Enemy3.tscn")
@onready var preLoadEnemy4 = preload("res://Scenes/Subscenes/Enemy4.tscn")

var playerID = -1
var player1
var player2

var enemyID = 1
var enemies = {}
var canSpawnEnemies = false
var completedChallangesCounter = 0

func _ready():
	for screen in get_tree().get_nodes_in_group("screen"):
		screen.has_finished.connect(ChallangeCompleted)

	if GameManager.isLAN():
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
					player2 = spawn_player("player2", player2_scene, player2_spawnPoint)
					# spawn remote player 1
					player1 = spawn_player("player1", player1_remote_scene, player1_spawnPoint)
					player2.remotePlayer1 = player1.get_node_or_null("Player1")
					# make ceiling invisible
					%World/Ceiling.queue_free()
	else:
		rng.randomize()
		player1 = spawn_player("player1", player1_scene, player1_spawnPoint)
		tier1timer.timeout.connect(_spawntimer_timeout.bind(1))
		tier2timer.timeout.connect(_spawntimer_timeout.bind(2))
		tier3timer.timeout.connect(_spawntimer_timeout.bind(3))
		tier4timer.timeout.connect(_spawntimer_timeout.bind(4))
		await get_tree().create_timer(5).timeout
		tier1timer.start()
		tier2timer.start()
		tier3timer.start()
		tier4timer.start()
				
func _spawntimer_timeout(tier):

	var randomIndex = rng.randi_range(0, enemySpawnPoints.size()-1)
	var randomSpawn = enemySpawnPoints[randomIndex]
	if player1.get_node_or_null("Player1").IntersectsSafeZone(randomSpawn.global_position):
		# if the randomly selected spawn point is inside the safe zone of the player skip it instead of re-roll to add randomness
		return

	SpawnEnemyAtPosition(tier, randomSpawn)

func SpawnEnemyAtPosition(tier, spawnNode):
	var powerRequirement = tierToPower(tier)
	var enemyData = EnemyData.new("", powerRequirement, tier, spawnNode.global_position)
	var spawned_enemey = spawn_enemy_function(enemyData)
	enemySpawn.add_child(spawned_enemey, true)
	setup_enemy(spawned_enemey, enemyData)
	spawned_enemey.SetPlayer(player1)


func tierToPower(tier):
	if tier < 4:
		return tier * 10
	if tier >= 4:
		return 50
	
func tierToScene(tier) -> PackedScene:
	match tier:
		1:
			return preLoadEnemy1
		2: 
			return preLoadEnemy2
		3: 
			return preLoadEnemy3
		4: 
			return preLoadEnemy4
		_:
			return preLoadEnemy1

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
	var enemyData = null
	if GameManager.isLAN():
		enemyData = EnemyData.FromJSON(enemyDataJSON)
	else:
		enemyData = enemyDataJSON
	var spawned_enemy = tierToScene(enemyData.tier).instantiate()

	enemies[str(enemyID)] = {"enemy": spawned_enemy, "data": enemyData}
	enemyID += 1

	return spawned_enemy

# Gets called after the spawn_function has run
# At this point the node has been added and _ready has run
func _on_authority_spawned_enemy(node : Node):
	var enemiesCopy = enemies.duplicate(true)
	for index in enemiesCopy:
		if enemiesCopy[str(index)].enemy == node:
			setup_enemy(enemiesCopy[str(index)].enemy, enemiesCopy[str(index)].data)
	

func setup_enemy(spawned_enemy, enemyData):
	spawned_enemy.global_position = enemyData.spawn_position
	spawned_enemy.SetHealth(enemyData.power)

	if !GameManager.isLAN():
		return
	if playerID != -1:
		spawned_enemy.SetPlayer(player1)
		spawned_enemy.SetAuthoritiy(playerID)
	
	var enemyIndex = -1
	for index in enemies:
		if enemies[str(index)].enemy == spawned_enemy:
			enemyIndex = index
			break

	if enemyIndex != str(-1):
		enemies.erase(str(enemyIndex))


@rpc("any_peer", "call_remote")
func ask_player1_to_spawn_enemy(enemyData):
	if multiplayer.get_unique_id() == GameManager.GetGroundPlayerID():
		spawn_enemy_via_mp_spawner(enemyData)
		

@rpc("any_peer", "call_local")
func PlayerOneDied():
	if !GameManager.isLAN():
		loseScreen.show()

		tier1timer.stop()
		tier2timer.stop()
		tier3timer.stop()
		tier4timer.stop()
		
	else:
		if multiplayer.get_unique_id() == GameManager.GetGroundPlayerID():
			loseScreen.show()
		else:
			winScreen.show()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.queue_free()

@rpc("any_peer", "call_local")
func PlayerOneWon():
	player1.get_node_or_null("Player1").isDead = true
	if !GameManager.isLAN():
		winScreen.show()

		tier1timer.stop()
		tier2timer.stop()
		tier3timer.stop()
		tier4timer.stop()
		
	else:
		if multiplayer.get_unique_id() == GameManager.GetGroundPlayerID():
			winScreen.show()
		else:
			loseScreen.show()
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.queue_free()





func ChallangeCompleted():
	completedChallangesCounter += 1
	if completedChallangesCounter >= 4:
		await get_tree().create_timer(1).timeout
		PlayerOneWon.rpc()


func _on_back_to_main_pressed():
	GameManager.reset()

@rpc("any_peer", "call_remote")
func setChargeSpeed(speed):
	if player2 != null:
		player2.rechargeSpeed = speed

func _on_screen_has_started():
	setChargeSpeed.rpc(4)


func _on_screen_has_interupted():
	setChargeSpeed.rpc(2)


func _on_screen_has_finished():
	setChargeSpeed.rpc(2)
