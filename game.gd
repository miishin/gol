extends Node2D

var cell_dimension : float = 32.0
var window_size = 1024
var scale_vector : Vector2

var cell_path = preload("res://cell.tscn")
var cells = []
var size : int

var start = false

func _physics_process(delta):
	if start:
		next_gen()
	
func init_cells():
	var cell
	for row in range(size):
		var row_cells = []
		for col in range(size):
			cell = cell_path.instance()
			cell.position = convert_pos(Vector2(row, col))
			cell.scale_cell(scale_vector)
			row_cells.append(cell)
			if row > 0:
				var neighbor = cells[row - 1][col]
				cell.set_top(neighbor)
				neighbor.set_bot(cell)
			if col > 0:
				var neighbor = row_cells[col - 1]
				cell.set_left(neighbor)
				neighbor.set_right(cell)
			add_child(cell)
		cells.append(row_cells)
		
func convert_pos(pos : Vector2) -> Vector2:
	pos.x = pos.x * cell_dimension + (cell_dimension / 2)
	pos.y = pos.y * cell_dimension + (cell_dimension / 2)
	return pos
				
func _on_LineEdit_text_entered(new_text):
	size = int(new_text)
	var scale : float = window_size / size / cell_dimension
	cell_dimension = cell_dimension * scale
	scale_vector = Vector2(scale, scale)
	init_cells()
	randomize_cells()
	start = true

func randomize_cells():
	for row in cells:
		for cell in row:
			if randi() % 2 == 0:
				cell.kill()
			else:
				cell.alive()
				
func next_gen():
	var num_live
	var num_dead
	for row in cells:
		for cell in row:
			var count = cell.count_neighbors()
			if cell.alive:
				cell.next_state = count == 2 or count == 3
			else:
				cell.next_state = count == 3
	_go_next()		
			
			
func _go_next():
	for row in cells:
		for cell in row:
				cell.go_next()
