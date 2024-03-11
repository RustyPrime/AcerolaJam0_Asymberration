extends Control
class_name ScreenView

@onready var label : Label = $VBoxContainer/Label
@onready var progress : HSlider = $VBoxContainer/HSlider


func _ready():
	SetProgress(0)

func SetLabelText(text):
	label.text = text

func SetProgress(value):
	progress.value = value

func GetProgress():
	return progress.value