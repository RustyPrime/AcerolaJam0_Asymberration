extends Node3D
class_name Screen

signal has_finished

@export var initialText : String
@export var interactText : String
@export var doneText : String

@onready var screenView : ScreenView = $screen/SubViewport/ScreenView
@onready var successSound : AudioStreamPlayer3D = $SuccessSound


enum state{
	uninit,
	ready,
	inProgress,
	finished

}
var currentState : state = state.ready
var previousState : state = state.uninit

var progress : float = 0

func _ready():
	SetInitialText()
	currentState = state.ready


func SetInitialText():
	screenView.SetLabelText(initialText)

func SetInProgressText():
	screenView.SetLabelText(interactText)

func SetFinishedText():
	screenView.SetLabelText(doneText)

func HasFinished():
	return currentState == state.finished

func ResetProgress():
	if HasFinished():
		return

	screenView.SetProgress(0)
	progress = 0
	SetInitialText()
	currentState = state.ready

func StartProgess():
	if HasFinished(): 
		return
	currentState = state.inProgress

func _process(delta):
	if previousState != currentState and currentState == state.ready:
		SetInitialText()
		screenView.SetProgress(0)
	if currentState == state.inProgress:
		SetInProgressText()
		progress = progress + (10 * delta)
		if progress > 100:
			progress = 100
			currentState = state.finished
		screenView.SetProgress(progress)

	if previousState != currentState and currentState == state.finished:
		SetFinishedText()
		currentState = state.finished
		has_finished.emit()
		successSound.play()

	previousState = currentState