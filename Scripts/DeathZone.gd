extends Area3D




func _on_body_entered(body:Node3D):
	if !body.owner is Player1:
		body.queue_free()
	else: 
		body.owner.global_position = get_parent().get_node_or_null("Multiplayer/SpawnPoint1").global_position
	
