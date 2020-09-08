extends TileMap

class_name Grid

var grid = []
var height: int
var width: int

var growed = 0
const GRID_GROW_SIZE = 5
const TILE_ID = 1

func _ready():
	var rect = get_used_rect()
	
	# Subtract existing blocks for the ground and walls
	height = rect.size.y - 1
	width = rect.size.x - 2
	
	for y in range(height):
		grid.append([])
		grid[y].resize(width)

func is_valid_position(pos: Vector2) -> bool:
	var grid_pos = _get_grid_position(pos)
	return grid_pos.y <= 0 and grid_pos.x >= 0 and grid_pos.x < width \
		and get_block_at(pos) == null

func get_block_at(pos: Vector2):
	var normalized = normalized_position(pos)
	return grid[normalized.y][normalized.x]

func normalized_position(pos: Vector2) -> Vector2:
	# In 2D upward y axis is negative
	var local_pos = _get_grid_position(pos)
	return Vector2(local_pos.x, abs(local_pos.y) - growed * GRID_GROW_SIZE)

func is_below_grid(pos: Vector2) -> bool:
	return normalized_position(pos).y < 0

func extend_grid_height() -> void:
	var rect = get_used_rect() as Rect2
	var max_y = rect.position.y # Position starts at left top corner
	var min_y = (rect.position.y + rect.size.y) - GRID_GROW_SIZE

	for i in range(GRID_GROW_SIZE):
		grid.append([])
		grid.back().resize(width)
		set_cell(rect.position.x, max_y - i - 1, TILE_ID)
		set_cell(rect.position.x + width + 1, max_y - i - 1, TILE_ID)
		
		var line = grid.pop_front()
		_delete_line_items(line)
		
	for cell in get_used_cells():
		if cell.y > min_y:
			set_cellv(cell, -1)
		
	growed += 1

func _get_grid_position(pos: Vector2) -> Vector2:
	# Minus one to make it zero-based
	var x = ceil(pos.x / cell_size.x) - 1

	# Y axis is already zero-based?
	var y = ceil(pos.y / cell_size.x)

	return Vector2(x, y)

func put_blocks(blocks: Array) -> void:
	for block in blocks:
		var pos = normalized_position(block.global_position)
		if pos.y < 0:
			block.queue_free()
		else:
			grid[pos.y][pos.x] = block

	_clear_full_lines()
	_clear_empty_shaped_blocks()

func _clear_empty_shaped_blocks() -> void:
	for child in get_children():
		var empty = true
		for block in child.blocks:
			if block != null:
				empty = false

		if empty:
			child.queue_free()

func _clear_full_lines() -> void:
	for y in range(height-1, -1, -1):
		var line = grid[y]
		if _is_full_line(line):
			_delete_line(y)
			_shift_blocks_down(y)

func _shift_blocks_down(start_height: int) -> void:
	for y in range(start_height, height):
		for x in range(width):
			var item = grid[y][x]
			if item != null:
				grid[y-1][x] = item
				grid[y][x] = null
				item.move_down()

func _delete_line(height: int) -> void:
	for x in range(width):
		# This automatically sets the item to null
		grid[height][x].queue_free()
		grid[height][x] = null
		
func _delete_line_items(line: Array) -> void:
	for item in line:
		if item != null:
			item.queue_free()
		
func _is_full_line(line: Array) -> bool:
	for item in line:
		if item == null:
			return false
	return true
