extends Node3D


@onready var slider :HSlider = $UI/Control/HSlider
@onready var level = get_node("/root/Level")


@export var rechargeSpeed = 10

func _ready():
	for node in get_tree().get_nodes_in_group("draggable"):
		node.try_spawn_unit.connect(_try_spawn_unit)

func _process(delta):
	slider.value = slider.value + (rechargeSpeed * delta)


func _try_spawn_unit(unit_path, unit_value, unit_position):
	if slider.value < unit_value: 
		return
	slider.value -= unit_value
	if slider.value < 0:
		slider.value = 0
	level.spawn_unit.rpc(unit_path, unit_position)