extends Area2D
## A single clickable hex. Can be active or inactive

## emits if the mouse is inside the hex and the LMB is clicked
signal clicked

## The hex should know its own position in grid doubled coordinates
## for faster position access
@export var doubled_position: Vector2i

## check if mouse cursor is currently inside the hex
var mouse_inside = false

func _ready():
	pass

func _process(delta):
	# emit clicked signal if LMB has been clicked within the hex
	if Input.is_action_just_pressed("ui_click"):
		if mouse_inside:
			clicked.emit(self)

func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false

