extends Node3D

@onready var animTree : AnimationTree = $AnimationTree
@onready var screen : Screen = $Screen
@onready var stepOnSound : AudioStreamPlayer3D = $StepOnSound
@onready var stepOffSound : AudioStreamPlayer3D = $StepOffSound



func play():
	animTree.set("parameters/conditions/pressed", true)
	animTree.set("parameters/conditions/unpressed", false)
	screen.StartProgess()
	

func stop():
	animTree.set("parameters/conditions/pressed", false)
	animTree.set("parameters/conditions/unpressed", true)
	if !screen.HasFinished():
		screen.ResetProgress()


func _on_area_3d_body_entered(body:Node3D):
	if body.owner is PlayerRig:
		play()
		stepOnSound.play()

func _on_area_3d_body_exited(body:Node3D):
	if body.owner is PlayerRig:
		stop()
		stepOffSound.play()
