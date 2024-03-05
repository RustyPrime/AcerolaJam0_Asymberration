extends CharacterBody3D
class_name Player1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var BULLET_SPEED = 150.0
@export var sensitivity = 700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var original_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var bullet : PackedScene = load("res://Scenes/Subscenes/bullet.tscn")
@onready var muzzle : Node3D = %Muzzle
@onready var collisionShape : CollisionShape3D = $CollisionShape3D
@onready var level = get_node("/root/Level")
@onready var rng = RandomNumberGenerator.new()
@onready var safeZone : CollisionShape3D = $SafeZone/Area3D/CollisionShape3D
@onready var camera : Node3D = $Head

var spaceState : PhysicsDirectSpaceState3D

var mouse_input : Vector2
var rotation_target: Vector3

var isMouseCaptured = true
var isInverted = false
var wasInverted = false

var safeZoneRadius : float
var playerHeight : float
var shotID : int = 0


func _ready():
	safeZoneRadius = safeZone.shape.radius
	
	if !hasAuthority():
		return
		
	rng.randomize()

	playerHeight = collisionShape.shape.height
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func IntersectsSafeZone(potentialUnitSpawnPosition):
	var playerPosition = Vector3(global_position.x, 0, global_position.z)
	potentialUnitSpawnPosition.y = 0
	var distanceToPlayer = playerPosition.distance_to(potentialUnitSpawnPosition)
	if abs(distanceToPlayer) < safeZoneRadius:
		return true
	return false


func _process(_delta):
	if !hasAuthority():
		return

	mouse_input = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("shoot"):
		var spreadData : Dictionary = {	}
		var index = 0
		var shotCount = rng.randi_range(5, 10)
		for shots in shotCount:
			spreadData[index] = {
				"angle" : rng.randi_range(0, 360), 
				"spread": randomSpread()}
			index += 1
		spreadData["shotID"] = shotID
		spreadData["shotCount"] = shotCount
		shoot.rpc(JSON.stringify(spreadData))	
		shotID += 1

func randomSpread():
	var randomSpreadRange = rng.randf_range(0, 0.1)
	if (randomSpreadRange > 0.05):
		if rng.randi_range(0, 4) <= 3:
			randomSpreadRange = rng.randf_range(0, 0.05)
	return randomSpreadRange


func _physics_process(delta):
	if spaceState == null:
		spaceState = level.get_world_3d().direct_space_state

	if !hasAuthority():
		return

	handle_mouse_capture()
	# Add the gravity.
	if not is_on_floor() :
		velocity.y -= gravity * delta

	handle_camera_rotation(delta)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	handle_movement()
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and isMouseCaptured:
		mouse_input = event.relative / sensitivity
		rotation_target.y -= event.relative.x / sensitivity
		rotation_target.x -= event.relative.y / sensitivity

func handle_movement():
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var forward = input_dir.y
	if isInverted:
		forward *= -1
	var right = input_dir.x
	if isInverted:
		right *= -1
	var direction = (transform.basis * Vector3(right, 0, forward)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func handle_camera_rotation(delta):
	if camera == null:	
		return

	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	if camera.rotation_degrees.x >= 360:
		camera.rotation_degrees.x -= 360
	if camera.rotation_degrees.x <= -360:
		camera.rotation_degrees.x += 360

	if camera.rotation_degrees.x > 90 or camera.rotation_degrees.x < -90:
		rotation.y = lerp_angle(rotation.y, rotation_target.y * -1, delta * 25)
		rotation_degrees.z = 180
		camera.rotation_degrees.z = 180
		
		isInverted = true
		up_direction = Vector3.UP * -1
		gravity = original_gravity * -1
		if wasInverted != isInverted:
			global_position.y = global_position.y + playerHeight + (playerHeight * 0.1)
			wasInverted = isInverted

	else:
		rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
		rotation_degrees.z = 0
		camera.rotation_degrees.z = 0
		isInverted = false
		up_direction = Vector3.UP
		gravity = original_gravity
		if wasInverted != isInverted:
			global_position.y = global_position.y - playerHeight - (playerHeight * 0.1)
			wasInverted = isInverted

func handle_mouse_capture():
	if !isMouseCaptured and Input.is_action_just_pressed("mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		isMouseCaptured = true
	if Input.is_action_just_pressed("mouse_capture_exit"):
		mouse_input = Vector2.ZERO
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		isMouseCaptured = false

func hasAuthority():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

@rpc("any_peer", "call_local")
func shoot(spread_data):
	var spreadData = JSON.parse_string(spread_data)
	for index in spreadData["shotCount"]:
		var data = spreadData[str(index)]

		var spawned_bullet = bullet.instantiate()
		get_tree().root.add_child(spawned_bullet, true)
		spawned_bullet.name = "shot_" + str(spreadData["shotID"]) + "_" + str(index)
		spawned_bullet.global_position = muzzle.global_position

		var randomAngle = data["angle"]
		var forward = muzzle.global_transform.basis.z
		var right = muzzle.global_transform.basis.x
		var right_rotated = right.rotated(forward.normalized(), deg_to_rad(randomAngle))
		
		var direction = (forward + (right_rotated * data["spread"]))
	
		spawned_bullet.apply_force((direction) * BULLET_SPEED)

	
	

