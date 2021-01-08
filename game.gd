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
				var top_neighbor = cells[row - 1][col]
				cell.set_top(top_neighbor)
				top_neighbor.set_bot(cell)
			if col > 0:
				var left_neighbor = row_cells[col - 1]
				cell.set_left(left_neighbor)
				left_neighbor.set_right(cell)
			add_child(cell)
		cells.append(row_cells)
	set_diagonal_neighbors()
	
func set_diagonal_neighbors():
	var botr
	var botl
	var topl
	var topr
	for row in range(size):
		for di in range(1, size - row):
			botr = cells[row + di][di]
			topl = cells[row + di - 1][di - 1]
			topl.set_botr(botr)
			botr.set_topl(topl)
	for col in range(1, size):
		for di in range(1, size - col):		
			botl = cells[col + di][-di]
			topr = cells[col - di - 1][di + 1]
			botl.set_topr(topr)
			topr.set_botl(botl)
			
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
			cell.set_next_state()
	_go_next()		
			
			
func _go_next():
	for row in cells:
		for cell in row:
				cell.go_next()
