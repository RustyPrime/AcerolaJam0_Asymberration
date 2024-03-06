extends Node3D


@onready var slider : HSlider = $UI/Panel/HSlider
@onready var dragHandler : Control = $UI/Panel/DragHandler
@onready var level = get_node("/root/Level")
@onready var navigationRegion3D : NavigationRegion3D = get_node("/root/Level/World/NavigationRegion3D")
@export var rechargeSpeed = 10

var remotePlayer1 : Player1

func _ready():
	dragHandler.try_spawn_unit.connect(_try_spawn_unit)

func _process(delta):
	slider.value = slider.value + (rechargeSpeed * delta)


func _try_spawn_unit(unitData):
	if !IsValidSpawn(unitData):
		return	

	slider.value -= unitData.power
	if slider.value < 0:
		slider.value = 0
	var unit_name = "unit_" + str(get_tree().get_nodes_in_group("unit").size() + 1)
	unitData.name = unit_name
	level.spawn_unit.rpc(unitData.ToJson())

func IsValidSpawn(unitData):
	if slider.value < unitData.power: 
		return false
	
	var spawnPosition = NavigationServer3D.map_get_closest_point(navigationRegion3D.get_navigation_map(), unitData.spawn_position)
	unitData.spawn_position = spawnPosition
	if remotePlayer1.IntersectsSafeZone(spawnPosition):
		return false
	
	return true

	
