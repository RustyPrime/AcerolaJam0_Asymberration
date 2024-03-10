extends CharacterBody3D
class_name Enemy

@export var particles : GPUParticles3D

@onready var multiplayerSynchronizer : MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var navMesh: NavigationAgent3D = $NavigationAgent3D
@onready var healthDisplay: Label3D = $HealthDisplay
@onready var destroyTimer : Timer = $Timer

var movementSpeed = 2
var acceleration = 10
var health = 2
var playerToChase : Player1
var destroying = false
var material : Material
var originalMaterialColor : Color

func _ready():
	
	material = particles.draw_pass_1.surface_get_material(0)
	originalMaterialColor = material.albedo_color
	
	if GameManager.isLAN():
		var groundPlayerID = GameManager.GetGroundPlayerID()
		SetAuthoritiy(groundPlayerID)

	if !HasAuthority():
		return

	healthDisplay.text = str(health)


func SetPlayer(player):
	playerToChase = player.get_node("Player1")

func SetHealth(enemyPower):
	health *= enemyPower
	if healthDisplay == null:
		healthDisplay = $HealthDisplay
	healthDisplay.text = str(health)

func SetAuthoritiy(id = 1):
	multiplayerSynchronizer.set_multiplayer_authority(id)

func HasAuthority():
	return !GameManager.isLAN() or multiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
	

func _physics_process(delta):
	if !HasAuthority():
		return 

	if playerToChase != null:
		navMesh.target_position = playerToChase.global_position

		var direction = navMesh.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * movementSpeed, acceleration * delta)

		move_and_slide()

@rpc("any_peer", "call_local")
func DoDamage(damage):
	#print("DoDamage rpc")
	health -= damage

	material.albedo_color = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	material.albedo_color = originalMaterialColor

	if health < 0:
		health = 0
	healthDisplay.text = str(health)
	if health <= 0:
		Die()
	

func Die():
	if destroying: 
		return

	multiplayerSynchronizer.public_visibility = false
	
	destroying = true
	hide()
	
	global_position.y -= 50
	destroyTimer.start()
 	

func _on_timer_timeout():
	if destroying and !visible:
		queue_free()
