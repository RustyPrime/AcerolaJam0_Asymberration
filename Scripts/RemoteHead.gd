extends Node3D


@onready var camera = $SubViewport/Camera3D

func _process(_delta):
	camera.global_position = global_position
	camera.global_rotation = global_rotation