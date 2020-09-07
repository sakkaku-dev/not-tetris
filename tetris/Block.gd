extends Node2D

class_name Block

onready var texture := $Texture
onready var block_size: int = texture.texture.get_height()

func set_color(color: Color) -> void:
	texture.modulate = color

func move_up() -> void:
	global_translate(Vector2.UP * block_size)

func move_down() -> void:
	global_translate(Vector2.DOWN * block_size)

func move_left() -> void:
	global_translate(Vector2.LEFT * block_size)
		
func move_right() -> void:
	global_translate(Vector2.RIGHT * block_size)

func get_grid_position() -> Vector2:
	# Minus one to make it zero-based
	var x = ceil(global_position.x / block_size) - 1

	# Y axis is already zero-based?
	var y = ceil(global_position.y / block_size)

	return Vector2(x, y)
