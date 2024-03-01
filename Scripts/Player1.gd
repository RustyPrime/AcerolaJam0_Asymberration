extends CharacterBody3D
class_name Player1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var BULLET_SPEED = 150.0
@export var sensitivity = 700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var bullet : PackedScene = load("res://Scenes/Subscenes/bullet.tscn")
@onready var muzzle = $Head/Shotgun/Muzzle
var camera

var mouse_input : Vector2
var rotation_target: Vector3
var isMouseCaptured = true

func _ready():
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(_delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	mouse_input = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("shoot"):
		shoot.rpc()	

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return

	handle_mouse_capture()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Camera Rotation
	camera = $Head
	if camera != null:
		#camera.rotation.z = lerp_angle(camera.rotation.z, -mouse_input.x * 25 * delta, delta * 5)	
		camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	

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

func _input(event):
	if event is InputEventMouseMotion and isMouseCaptured:
		mouse_input = event.relative / sensitivity
		rotation_target.y -= event.relative.x / sensitivity
		rotation_target.x -= event.relative.y / sensitivity

func handle_mouse_capture():
	if !isMouseCaptured and Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		isMouseCaptured = true
	if Input.is_action_just_pressed("mouse_capture_exit"):
		mouse_input = Vector2.ZERO
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		isMouseCaptured = false

@rpc("any_peer", "call_local")
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
	spawned_bullet.global_position = muzzle.global_position
	spawned_bullet2.global_position = muzzle.global_position
	spawned_bullet3.global_position = muzzle.global_position
	spawned_bullet4.global_position = muzzle.global_position
	spawned_bullet5.global_position = muzzle.global_position
	#spawned_bullet.global_rotation = muzzle.global_rotation
	spawned_bullet.apply_force(muzzle.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet2.apply_force(muzzle.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet3.apply_force(muzzle.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet4.apply_force(muzzle.get_global_transform().basis.z * BULLET_SPEED)
	spawned_bullet5.apply_force(muzzle.get_global_transform().basis.z * BULLET_SPEED)
