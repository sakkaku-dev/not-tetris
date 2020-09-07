extends Node2D

class_name ShapedBlock

signal block_placed

export var color: Color

onready var blocks := [$BlockRotation/Block, $BlockRotation/Block2, $BlockRotation/Block3, $BlockRotation/Block4]
onready var block_size: int = blocks[0].block_size

var placed = false

func _ready():
	for block in blocks:
		block.set_color(color)

func rotate_block() -> void:
	rotate(deg2rad(90))

func rotate_back() -> void:
	rotate(deg2rad(-90))

func move_up() -> void:
	global_translate(Vector2.UP * block_size)

func move_down() -> void:
	global_translate(Vector2.DOWN * block_size)

func move_left() -> void:
	global_translate(Vector2.LEFT * block_size)
		
func move_right() -> void:
	global_translate(Vector2.RIGHT * block_size)

func any_block_invalid(grid: Grid) -> bool:
	for block in blocks:
		if not grid.is_valid_position(block.get_grid_position()):
			return true
	return false
