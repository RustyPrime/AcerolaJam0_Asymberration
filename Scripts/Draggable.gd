extends TextureButton
class_name Draggable

signal is_being_dragged(draggable : Draggable)
signal stopped_dragging(draggable : Draggable)

var originalPosition : Vector2
var unitData : UnitData

@export var unit : PackedScene
@export var powerRequirement : float = 10.0

func _ready():
	originalPosition = global_position
	unitData = UnitData.new("", powerRequirement, unit.resource_path)

func resetDraggable():
	global_position = originalPosition

func _on_button_down():
	is_being_dragged.emit(self)

func _on_button_up():
	stopped_dragging.emit(self)
