extends RigidBody3D
class_name Bullet

var damage = 2
var destroying = false
@onready var destroyTimer : Timer = $Timer

func _ready():
	self.set_multiplayer_authority(GameManager.GetGroundPlayerID())


func _on_body_entered(body:Node):
	if self.get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	if body is Enemy:
		body.DoDamage.rpc(damage)
		
	if !destroying:
		destroyBullet.rpc()	

@rpc("any_peer", "call_local")
func destroyBullet():
	if destroying: 
		return

	destroying = true
	hide()
	
	linear_velocity = Vector3.ZERO
	global_position.y -= 50
	destroyTimer.start()


func _on_timer_timeout():
	if !visible:
		queue_free()
