extends Node3D

signal interacted

@onready var animTree : AnimationTree = $AnimationTree
@onready var stepOnSound : AudioStreamPlayer3D = $StepOnSound
@onready var stepOffSound : AudioStreamPlayer3D = $StepOffSound
@onready var screen : Screen = get_node_or_null("Screen")




func play():
	animTree.set("parameters/conditions/pressed", true)
	animTree.set("parameters/conditions/unpressed", false)
	if screen != null:
		screen.StartProgess()
	

func stop():
	animTree.set("parameters/conditions/pressed", false)
	animTree.set("parameters/conditions/unpressed", true)
	if screen != null and !screen.HasFinished():
		screen.ResetProgress()


func _on_area_3d_body_entered(body:Node3D):
	if body.owner is PlayerRig:
		play()
		stepOnSound.play()
		interacted.emit()

func _on_area_3d_body_exited(body:Node3D):
	if body.owner is PlayerRig:
		stop()
		stepOffSound.play()
