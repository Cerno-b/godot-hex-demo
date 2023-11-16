extends Node
## This node contains the main playfield, which will get
## Hex nodes added dynamically as more hex fields are added over the
## course of the game.

## width of a single hex cell
const HEX_WIDTH = 40
## height of a single hex cell = sqrt(3) * width/2
const HEX_HEIGHT = 34

## starting grid in "doubled coordinates"
const HEX_START_GRID = [
		Vector2i(0, 0),
		Vector2i(0, 2), Vector2i(0, -2),
		Vector2i(1, -1), Vector2i(1, 1),
		Vector2i(-1, -1), Vector2i(-1, 1),
	]

@export var Hex: PackedScene

## stores the current state of the board for easy lookup
## keys are grid positions in "doubled coordinates", values are the hex Nodes
var hex_grid = Dictionary()

## Calculates the screen coordinates from doubled coordinates
func doubled_to_pixel(doubled_pos):
	var x = doubled_pos.x * HEX_WIDTH * 3 / 4
	var y = doubled_pos.y * HEX_HEIGHT / 2
	return Vector2i(x, y)

## Calculate cube coordinates from doubled coordinates
## (not used in this demo)
func doubled_to_cube(doubled_pos):
	var q = doubled_pos.x
	var r = (doubled_pos.y - doubled_pos.x) / 2
	return Vector3i(q, r, -q-r)

## Calculate doubled coordinates from cube coordinates
## (not used in this demo)	
func cube_to_doubled(cube_pos):
	var x = cube_pos.x
	var y = 2 * cube_pos.y + cube_pos.x
	return Vector2i(x, y)

## Initialize the grid according to HEX_START_GRID
## this draws the initial playing field
func init_grid():
	for doubled_position in HEX_START_GRID:
		var hex = add_hex(doubled_position)
		hex.get_node("HexSprite").animation = "normal"
	
	# draw clickable neighbors
	for hex_position in HEX_START_GRID:
		add_inactive_neighbors(hex_position)
	
## Attempt to add a clickable inactive neighbor hex for all 6 neighbor positions.
## This only actually adds a neighbor if the field is not yet occupied.
func add_inactive_neighbors(doubled_pos):
	add_inactive_hex_if_empty(doubled_pos + Vector2i(1,1))   # bottom right
	add_inactive_hex_if_empty(doubled_pos + Vector2i(1,-1))  # top right
	add_inactive_hex_if_empty(doubled_pos + Vector2i(-1,1))  # bottom left
	add_inactive_hex_if_empty(doubled_pos + Vector2i(-1,-1)) # top left
	add_inactive_hex_if_empty(doubled_pos + Vector2i(0,2))   # bottom
	add_inactive_hex_if_empty(doubled_pos + Vector2i(0,-2))  # top

## Attempt to add a clickable inactive hex if the position in the grid
## is not yet occupied
func add_inactive_hex_if_empty(doubled_pos):
	if doubled_pos not in hex_grid.keys():
		var hex = add_hex(doubled_pos)
		hex.get_node("HexSprite").animation = "inactive"

## Add a hex in a given position on the grid
func add_hex(doubled_pos):
	var hex = Hex.instantiate()
	add_child(hex)
	hex.position = doubled_to_pixel(doubled_pos)
	hex.doubled_position = doubled_pos  # the hex needs to know its own position for reference
	hex_grid[doubled_pos] = hex
	hex.connect("clicked", _on_hex_clicked)
	return hex

func _ready():
	init_grid()

func _process(delta):
	pass

## When an inactive hex is clicked, convert it to a normal one and attempt
## to fill all 6 neighbor fields with new inactive hexes, but only if that
## space is not yet occupied.
func _on_hex_clicked(hex):
	if hex.get_node("HexSprite").animation == "inactive":
		hex.get_node("HexSprite").animation = "normal"
		add_inactive_neighbors(hex.doubled_position)
		
