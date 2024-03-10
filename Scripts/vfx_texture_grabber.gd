extends Node3D

@export var vfx : Node3D
@onready var camera = $Camera3D

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		var image = get_viewport().get_texture().get_image()
		#image.flip_y()
		image.save_png("Textures/"+vfx.name+".png")
	