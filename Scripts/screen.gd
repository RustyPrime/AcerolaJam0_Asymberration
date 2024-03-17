extends Node3D
class_name Screen

signal has_started
signal has_interupted
signal has_finished

@export var initialText : String
@export var interactText : String
@export var doneText : String

@onready var subviewPort : SubViewport = $screen/SubViewport
@onready var screenMeshInstance : MeshInstance3D = $screen/MeshInstance3D

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
	RenderingServer.frame_post_draw.connect(_on_frame_post_draw)

func _on_frame_post_draw():
	var viewPortTexture = subviewPort.get_texture()
	var material : StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_texture = viewPortTexture
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	screenMeshInstance.set_surface_override_material(0, material)
	RenderingServer.frame_post_draw.disconnect(_on_frame_post_draw)

func SetInitialText():
	screenView.SetLabelText(initialText)

func SetInProgressText():
	screenView.SetLabelText(interactText)

func SetFinishedText():
	screenView.SetLabelText(doneText)

func HasFinished():
	return currentState == state.finished

func IsInProgress():
	return currentState == state.inProgress

func ResetProgress():
	if HasFinished():
		return
	has_interupted.emit()
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
		if previousState != currentState:
			has_started.emit()
			
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