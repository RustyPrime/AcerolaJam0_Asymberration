extends RigidBody3D
class_name Bullet

var damage = 2
@onready var mpSyncher = $MultiplayerSynchronizer

func _ready():
	mpSyncher.set_multiplayer_authority(GameManager.GetGroundPlayerID())

func _on_body_entered(body:Node):
	if mpSyncher.get_multiplayer_authority() != GameManager.GetGroundPlayerID():
		return

	if body.owner is Unit:
		body.owner.DoDamage.rpc(damage)

	if body != owner and !body is Player1 and !body is Bullet:
		destroyBullet.rpc()


@rpc("any_peer", "call_local")
func destroyBullet():
	print("destroyBullet rpc")
	queue_free()

func _on_timer_timeout():
	destroyBullet.rpc()
