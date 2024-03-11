extends DestructableTarget
class_name SpecialTarget

@onready var impostorTarget : Node3D = $Impostor
@onready var impostorArea : CollisionShape3D = $Impostor/Area3D/CollisionShape3D
@onready var realTarget : Node3D = $Target

@onready var impostorSound : AudioStreamPlayer3D = $Impostor/SpecialEnemySound
@onready var successSound : AudioStreamPlayer3D = $Impostor/SuccessSound
@onready var level = get_node_or_null("/root/Level")

var player1 : Player1
func _ready():
	death.connect(_on_death)
	player1 = get_tree().get_first_node_in_group("player1")

func isFacedByPlayer(threshold):
	if player1 == null:
		player1 = get_tree().get_first_node_in_group("player1")
		return false
	if global_position.distance_to(player1.global_position) < 1.0:
		return true

	var playerForward = -player1.global_transform.basis.z
	var playerPosition = player1.global_position
	if abs(playerPosition.direction_to(self.global_position).x - playerForward.x) < threshold:
		if abs(playerPosition.direction_to(self.global_position).y - playerForward.y) < threshold:
			return true
	return false

var prevFacing = false
func _process(_delta):

	var isPlayerFacing = isFacedByPlayer(0.2)
	
	if isPlayerFacing == prevFacing:
		return
	
	if isPlayerFacing:
		impostorArea.disabled = true
		realTarget.show()
		impostorTarget.hide()
		impostorSound.stop()
	else:
		realTarget.hide()
		impostorTarget.show()
		impostorArea.disabled = false
		impostorSound.play()

	prevFacing = isPlayerFacing


func _on_death():
	successSound.play()
	level.ChallangeCompleted()
