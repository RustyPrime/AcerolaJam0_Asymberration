extends RigidBody3D




func _on_body_entered(body:Node):
	print("body entered unit")
	if body is Bullet:
		queue_free()
