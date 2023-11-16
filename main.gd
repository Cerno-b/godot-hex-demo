extends Node
## A simple hex game demo to test drawing and interacting with hex grids
## Refer to the amazing https://www.redblobgames.com/grids/hexagons/
## The demo is heavily based on that collection of information.
## Get more details about doubled coordinates there.

func _ready():
	pass
		

func _process(delta):
	# Esc to quit
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
