extends RigidBody3D
class_name Unit


@onready var multiplayerSynchronizer : MultiplayerSynchronizer = $MultiplayerSynchronizer

var health = 2

func SetHealth(unitPower):
	health *= unitPower

func SetAuthoritiy(id = 1):
	multiplayerSynchronizer.set_multiplayer_authority(id)

func _on_body_entered(body:Node):
	if body is Bullet:
		queue_free()
