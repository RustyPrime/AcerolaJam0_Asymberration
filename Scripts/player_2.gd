extends Node3D


@onready var slider : HSlider = $UI/Panel/HSlider
@onready var dragHandler : Control = $UI/Panel/DragHandler
@onready var spawnSound : AudioStreamPlayer3D = $SpawnSound
@onready var noSpawnSound : AudioStreamPlayer3D = $NoSpawnSound
@onready var player1view : TextureRect = $Camera3D/CanvasLayer/Player1View
@onready var level = get_node_or_null("/root/Level")
@onready var navigationRegion3D : NavigationRegion3D = get_node_or_null("/root/Level/World/NavigationRegion3D")

@export var rechargeSpeed : float = 5.0
var charge : float = 0.0

var remotePlayer1 : Player1

func _ready():
	dragHandler.try_spawn_enemy.connect(_try_spawn_enemy)

func SetPlayerOne(player1):
	remotePlayer1 = player1
	var remotePlayer1View = remotePlayer1.get_node_or_null("Head/SubViewport/Camera3D")
	if remotePlayer1View != null:
		player1view.texture = remotePlayer1View.get_viewport().get_texture()


func _process(delta):
	charge += (rechargeSpeed * delta)
	if charge >= 100:
		charge = 100
	slider.value = charge
	if rechargeSpeed == 2.0:
		if slider.has_theme_stylebox_override("grabber_area"):
			slider.get_theme_stylebox("grabber_area").color = Color.GREEN
	else:
		if slider.has_theme_stylebox_override("grabber_area"):
			slider.get_theme_stylebox("grabber_area").color = Color.YELLOW


func _try_spawn_enemy(enemyData):
	if !IsValidSpawn(enemyData):
		noSpawnSound.play()
		return	

	charge -= enemyData.power
	if charge < 0:
		charge = 0
	var enemy_name = "enemy_" + str(get_tree().get_nodes_in_group("enemy").size() + 1)
	enemyData.name = enemy_name
	level.ask_player1_to_spawn_enemy.rpc(enemyData.ToJson())
	spawnSound.play()
	

func IsValidSpawn(enemyData):
	if slider.value < enemyData.power: 
		return false
	
	var spawnPosition = NavigationServer3D.map_get_closest_point(navigationRegion3D.get_navigation_map(), enemyData.spawn_position)
	enemyData.spawn_position = spawnPosition
	if remotePlayer1.IntersectsSafeZone(spawnPosition):
		return false
	
	return true

	
