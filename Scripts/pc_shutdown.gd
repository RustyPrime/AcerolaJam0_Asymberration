extends Node3D


@onready var screen : Screen = $Screen
@onready var interactSound : AudioStreamPlayer3D = $InteractSound
var playerInRange : bool = false


func _ready():
	set_multiplayer_authority(GameManager.GetGroundPlayerID())

	screen.has_finished.connect(_on_screen_has_finished)


func _on_screen_has_finished():
	screen.hide()


func _process(_delta):
	if playerInRange:
		if Input.is_action_just_pressed("interact"):
			if !screen.IsInProgress() and !screen.HasFinished():
				screen.StartProgess()
				interactSound.play()



func _on_area_3d_body_entered(body:Node3D):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	if body.owner is PlayerRig:
		playerInRange = true


func _on_area_3d_body_exited(body:Node3D):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	if body.owner is PlayerRig:
		playerInRange = false
		if !screen.HasFinished():
			screen.ResetProgress()
