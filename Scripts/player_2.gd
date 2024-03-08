extends Node3D


@onready var slider : HSlider = $UI/Panel/HSlider
@onready var dragHandler : Control = $UI/Panel/DragHandler
@onready var level = get_node("/root/Level")
@onready var navigationRegion3D : NavigationRegion3D = get_node("/root/Level/World/NavigationRegion3D")
@export var rechargeSpeed = 10

var remotePlayer1 : Player1

func _ready():
	dragHandler.try_spawn_enemy.connect(_try_spawn_enemy)

func _process(delta):
	slider.value = slider.value + (rechargeSpeed * delta)


func _try_spawn_enemy(enemyData):
	if !IsValidSpawn(enemyData):
		return	

	slider.value -= enemyData.power
	if slider.value < 0:
		slider.value = 0
	var enemy_name = "enemy_" + str(get_tree().get_nodes_in_group("enemy").size() + 1)
	enemyData.name = enemy_name
	level.ask_player1_to_spawn_enemy.rpc(enemyData.ToJson())
	#level.spawn_enemy(enemyData.ToJson())

func IsValidSpawn(enemyData):
	if slider.value < enemyData.power: 
		return false
	
	var spawnPosition = NavigationServer3D.map_get_closest_point(navigationRegion3D.get_navigation_map(), enemyData.spawn_position)
	enemyData.spawn_position = spawnPosition
	if remotePlayer1.IntersectsSafeZone(spawnPosition):
		return false
	
	return true

	
