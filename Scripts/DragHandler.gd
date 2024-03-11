extends Control

signal try_spawn_enemy(enemyData)

var spaceState : PhysicsDirectSpaceState3D
var currentDraggable : Draggable
var mousePosition

@onready var level = get_node_or_null("/root/Level")


func _ready():
	var draggables = get_tree().get_nodes_in_group("draggable")
	for draggable in draggables:
		draggable.is_being_dragged.connect(on_is_dragging)
		draggable.stopped_dragging.connect(on_stopped_dragging)

func _physics_process(_delta):
	if spaceState == null:
		spaceState = level.get_world_3d().direct_space_state
		
func _process(_delta):
	if currentDraggable != null:
		currentDraggable.global_position = mousePosition - Vector2(currentDraggable.size.x / 2, currentDraggable.size.y / 2)

func on_is_dragging(button : Draggable):
	currentDraggable = button

func on_stopped_dragging(draggable : Draggable):
	if currentDraggable == null:
		return

	if currentDraggable == draggable:
		var rayHitData = ScreenPointToRay()
		if IsValidSpawn(rayHitData):
			draggable.enemyData.spawn_position = rayHitData["position"]
			try_spawn_enemy.emit(draggable.enemyData)
		
		draggable.resetDraggable()
		currentDraggable = null


func _input(event):
	if event is InputEventMouseMotion:
		mousePosition = event.position
			
func IsValidSpawn(rayHitData):
	if rayHitData == null:
		return false
	return true

func ScreenPointToRay():
	var camera = get_tree().root.get_camera_3d()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * 1000
	
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	rayQuery.exclude = [self]
	rayQuery.collide_with_bodies = true

	var rayHit = spaceState.intersect_ray(rayQuery)
	if rayHit.has("position"):
		return rayHit
	return null