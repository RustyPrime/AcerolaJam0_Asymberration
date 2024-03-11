extends Node3D
class_name Shotgun

@onready var shotgunAudio : AudioStreamPlayer3D = $ShotAudio
@onready var cockingAudio : AudioStreamPlayer3D = $CockingAudio
@onready var shotgunAnimation : AnimationTree = $AnimationTree

func shoot():
	shotgunAudio.play()
	shotgunAnimation.set("parameters/conditions/shot", true)
	shotgunAnimation.call_deferred("set", "parameters/conditions/shot", false)
	await get_tree().create_timer(0.4).timeout
	cockingAudio.play()