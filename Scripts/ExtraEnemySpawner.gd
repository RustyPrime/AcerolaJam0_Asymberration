extends Node3D

@onready var level : SceneManager = get_node_or_null("/root/Level")
@export var extraEnemySpawn : Node3D
var hasSpawnedExtraEnemies = false
@onready var rng = RandomNumberGenerator.new()

@export var extraEnemyCount : int = 5

func _ready():
	rng.randomize()

func _on_interacted():
	print("extra spawner triggered")
	if !GameManager.isLAN() and hasSpawnedExtraEnemies == false:
		SpawnRandomEnemies()
		hasSpawnedExtraEnemies = true


func SpawnRandomEnemies():
	for i in extraEnemyCount - 1:
		# when rolled tier is greater than 2 there is 70% chance to be rerolled into a lower tier
		var randomTier = rng.randi_range(1, 4)
		if randomTier > 2:
			var randomChance = rng.randi_range(0, 10)
			if randomChance <= 7:
				randomTier = rng.randi_range(1, 2)
		level.call_deferred("SpawnEnemyAtPosition", randomTier, extraEnemySpawn)