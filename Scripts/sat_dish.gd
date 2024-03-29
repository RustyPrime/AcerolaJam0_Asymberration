extends Node3D

signal interacted

@onready var animTree : AnimationTree = $AnimationTree
@onready var screen : Screen = $Screen
@onready var interactSound : AudioStreamPlayer3D = $InteractSound


var playerInRange : bool = false
func play():
	animTree.set("parameters/conditions/spinning", true)
	animTree.set("parameters/conditions/stop", false)
	interactSound.play()
	screen.StartProgess()

func stop():
	animTree.set("parameters/conditions/spinning", false)
	animTree.set("parameters/conditions/stop", true)
	

func _ready():
	if GameManager.isLAN():
		set_multiplayer_authority(GameManager.GetGroundPlayerID())

	screen.has_finished.connect(_on_screen_has_finished)

func _on_screen_has_finished():
	stop()


func _on_area_3d_body_entered(body:Node3D):
	if GameManager.isLAN() and get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	if body.owner is PlayerRig:
		playerInRange = true


func _process(_delta):
	if playerInRange:
		if Input.is_action_just_pressed("interact"):
			play()
			interacted.emit()

func _on_area_3d_body_exited(body:Node3D):
	if GameManager.isLAN() and get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	if body.owner is PlayerRig:
		playerInRange = false
		stop()
		screen.ResetProgress()
