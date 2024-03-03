extends Node3D


@onready var slider :HSlider = $UI/Control/HSlider
@onready var level = get_node("/root/Level")


@export var rechargeSpeed = 10

func _ready():
	for node in get_tree().get_nodes_in_group("draggable"):
		node.try_spawn_unit.connect(_try_spawn_unit)

func _process(delta):
	slider.value = slider.value + (rechargeSpeed * delta)


func _try_spawn_unit(unitData):
	if slider.value < unitData.power: 
		return
	slider.value -= unitData.power
	if slider.value < 0:
		slider.value = 0
	var unit_name = "unit_" + str(get_tree().get_nodes_in_group("unit").size() + 1)
	unitData.name = unit_name
	level.spawn_unit.rpc(unitData.ToJson())