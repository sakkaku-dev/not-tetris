extends Camera2D

export(int) var camera_offset = 16
export(int) var offset_step = 40

export var grid_path: NodePath
onready var grid: Grid = get_node(grid_path)

export var player_path: NodePath
onready var player := get_node(player_path)
onready var start_position := global_position

func _get_configuration_warning() -> String:
	return "Player missing" if player == null else ""

func _process(delta: float) -> void:
	var player_offset = global_position.y - player.global_position.y
	if player_offset > camera_offset:
		global_position.y -= offset_step

		var max_pos = _get_last_viewable_grid_pos()
		if global_position.y < max_pos.y:
			global_position.y = max_pos.y
			grid.extend_grid_height()
				
func _get_max_grid_y() -> int:
	var cells = grid.get_used_cells() as Array
	var max_height = 0
	for cell in cells:
		max_height = min(max_height, cell.y)
	return max_height

func _get_last_viewable_grid_pos() -> Vector2:
	var cell_size = grid.cell_size as Vector2
	var cell_height = cell_size.y
	var max_height = _get_max_grid_y()
		
	# Camera can view 24 cells in height
	# And add cell buffer to prevent blocks from getting outside
	var local_height = (max_height + 12 + 3) * cell_height
	return grid.global_position + Vector2(0, local_height)
	
