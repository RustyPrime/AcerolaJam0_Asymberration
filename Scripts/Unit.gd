extends CharacterBody3D
class_name Unit


@onready var multiplayerSynchronizer : MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var navMesh: NavigationAgent3D = $NavigationAgent3D
@onready var healthDisplay: Label3D = $HealthDisplay
@onready var destroyTimer : Timer = $Timer

var movementSpeed = 2
var acceleration = 10
var health = 2
var playerToChase : Player1
var destroying = false

func _ready():
	healthDisplay.text = str(health)


func SetPlayer(player):
	playerToChase = player.get_node("Player1")

func SetHealth(unitPower):
	health *= unitPower
	if healthDisplay == null:
		healthDisplay = $HealthDisplay
	healthDisplay.text = str(health)

func SetAuthoritiy(id = 1):
	multiplayerSynchronizer.set_multiplayer_authority(id)

func _on_body_entered(body:Node):
	#print("something touched unit: " + body.name)
	#print("owner: " + body.owner.name)
	if body is Bullet:
		queue_free()

func _physics_process(delta):
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
	if health < 0:
		health = 0
	healthDisplay.text = str(health)
	if health <= 0:
		Die()

func Die():
	if destroying: 
		return

	destroying = true
	hide()
	
	global_position.y -= 50
	destroyTimer.start()
 	
