extends Node2D
var dead_cell = preload("res://dead.png")
var alive_cell = preload("res://alive.png")

var neighbors = [null, null, null, null]
var alive : bool
var next_state : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	kill()
	
func kill():
	alive = false
	$Sprite.set_texture(dead_cell)
	
func alive():
	alive = true
	$Sprite.set_texture(alive_cell)

func scale_cell(scale_vector : Vector2):
	$Sprite.apply_scale(scale_vector)

func set_top(cell):
	neighbors[0] = cell
	

func set_bot(cell):
	neighbors[1] = cell
	
func set_left(cell):
	neighbors[2] = cell

func set_right(cell):
	neighbors[3] = cell

func count_neighbors():
	var a = 0
	for neighbor in neighbors:
		if neighbor:
			if neighbor.alive:
				a += 1
	return a

func go_next():
	if next_state:
		alive()
	else:
		kill()
