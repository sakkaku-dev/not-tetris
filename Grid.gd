extends TileMap

class_name Grid

var grid = []
var height: int
var width: int

func _ready():
	var rect = get_used_rect()
	
	# Subtract existing blocks for the ground and walls
	height = rect.size.y - 1
	width = rect.size.x - 2
	
	for y in range(height):
		grid.append([])
		grid[y].resize(width)

func is_valid_position(pos: Vector2) -> bool:
	return pos.y <= 0 and pos.x >= 0 and pos.x < width \
		and get_block_at(pos) == null

func get_block_at(pos: Vector2):
	# In 2D upward y axis is negative
	return grid[abs(pos.y)][pos.x]

func put_blocks(blocks: Array) -> void:
	for block in blocks:
		var pos = block.get_grid_position()
		grid[abs(pos.y)][pos.x] = block

	_clear_full_lines()

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
		
func _is_full_line(line: Array) -> bool:
	for item in line:
		if item == null:
			return false
	return true
