extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var BULLET_SPEED = 150.0


	

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var bullet : PackedScene = load("res://Scenes/Subscenes/bullet.tscn")

@onready var barrel = $Barrel

func _process(_delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func shoot():
	var spawned_bullet = bullet.instantiate()
	var spawned_bullet2 = bullet.instantiate()
	var spawned_bullet3 = bullet.instantiate()
	var spawned_bullet4 = bullet.instantiate()
	var spawned_bullet5 = bullet.instantiate()
	get_parent().add_child(spawned_bullet)
	get_parent().add_child(spawned_bullet2)
	get_parent().add_child(spawned_bullet3)
	get_parent().add_child(spawned_bullet4)
	get_parent().add_child(spawned_bullet5)
	spawned_bullet.global_position = barrel.global_position
	spawned_bullet2.global_position = barrel.global_position
	spawned_bullet3.global_position = barrel.global_position
	spawned_bullet4.global_position = barrel.global_position
	spawned_bullet5.global_position = barrel.global_position
	#spawned_bullet.global_rotation = barrel.global_rotation
	spawned_bullet.apply_force(barrel.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet2.apply_force(barrel.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet3.apply_force(barrel.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet4.apply_force(barrel.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet5.apply_force(barrel.get_global_transform().basis.z * BULLET_SPEED)