extends Node3D
class_name DestructableTarget

signal death

var health = 2
var destroying = false
@onready var destroyTimer : Timer = $Timer

@rpc("any_peer", "call_local")
func DoDamage(damage):
	print("hit target")
	health -= damage
	if health < 0:
		health = 0
		Die()


func Die():
	if destroying: 
		return
	death.emit()
	destroying = true
	hide()
	
	global_position.y -= 50
	destroyTimer.start()

func _on_timer_timeout():
	if destroying and !visible:
		queue_free()
