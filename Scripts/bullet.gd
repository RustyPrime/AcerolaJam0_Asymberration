extends RigidBody3D
class_name Bullet

var damage = 2
var destroying = false
func _ready():
	self.set_multiplayer_authority(GameManager.GetGroundPlayerID())

func _on_body_entered(body:Node):
	if self.get_multiplayer_authority() != GameManager.GetGroundPlayerID():
		return

	if body is Unit:
		body.DoDamage.rpc(damage)
		destroyBullet.rpc()
	else: 
		destroyBullet.rpc()

	


@rpc("any_peer", "call_local")
func destroyBullet():
	print(str(multiplayer.get_unique_id()) + ": destroyBullet rpc")
	print(str(multiplayer.get_unique_id()) + str(self.get_path()))
	get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")
	destroying = true

func _on_timer_timeout():
	if self.get_multiplayer_authority() != GameManager.GetGroundPlayerID():
		return

	if destroying:
		return
		
	destroyBullet.rpc()
