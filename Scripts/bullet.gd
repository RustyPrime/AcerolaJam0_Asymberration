extends RigidBody3D
class_name Bullet





func _on_body_entered(body:Node):
	

	if body != owner and !body is Player1 and !body is Bullet:
		print("body entered bullet" + body.name)

		queue_free()


func _on_timer_timeout():
	queue_free()
