extends TextureButton
class_name Draggable

signal is_being_dragged(draggable : Draggable)
signal stopped_dragging(draggable : Draggable)

@onready var infoSlider = $HSlider

var originalPosition : Vector2
var enemyData : EnemyData

@export var enemyTier : int = 1
@export var powerRequirement : float = 10.0

func _ready():
	originalPosition = position
	enemyData = EnemyData.new("", powerRequirement, enemyTier)
	infoSlider.value = powerRequirement

func resetDraggable():
	position = originalPosition

func _on_button_down():
	is_being_dragged.emit(self)

func _on_button_up():
	stopped_dragging.emit(self)
