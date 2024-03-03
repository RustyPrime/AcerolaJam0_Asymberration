extends Node2D


signal try_spawn_unit(unit_path, unit_value, unit_position)

@onready var level = get_node("/root/Level")


static var isDragging = false
var isBeingHovered = false
var isBeingDragged = false
var spaceState : PhysicsDirectSpaceState3D
var originalPosition : Vector2
var mousePosition

@export var unit : PackedScene
@export var powerRequirement : float = 10.0

var unitData : UnitData

func _ready():
	originalPosition = global_position
	unitData = UnitData.new("", powerRequirement, unit.resource_path)

func _physics_process(_delta):
	if spaceState == null:
		spaceState = level.get_world_3d().direct_space_state

	if isBeingHovered:
		if Input.is_action_pressed("shoot"):
			global_position = mousePosition
			isDragging = true
		elif Input.is_action_just_released("shoot"):
			print(mousePosition)
			var screenPointIn3d = ScreenPointToRay()
			if screenPointIn3d != null:
				unitData.spawn_position = screenPointIn3d
				try_spawn_unit.emit(unitData)
			resetDraggable()

	else:
		resetDraggable()


func _input(event):
	if event is InputEventMouseMotion:
		mousePosition = event.position


func _on_area_2d_mouse_entered():
	if !isDragging:
		isBeingHovered = true
		scale = Vector2.ONE * 1.05


func _on_area_2d_mouse_exited():
	scale = Vector2.ONE
	isBeingHovered = false

func resetDraggable():
	isDragging = false
	global_position = originalPosition

func ScreenPointToRay():
	var camera = get_tree().root.get_camera_3d()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePosition) * 1000
	
	var rayQuery = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	rayQuery.exclude = [self]
	rayQuery.collide_with_bodies = true

	var rayArray = spaceState.intersect_ray(rayQuery)
	if rayArray.has("position"):
		return rayArray["position"]
	return null
