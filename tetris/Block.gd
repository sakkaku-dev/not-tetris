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

func _on_Area2D_body_entered(body: Player):
	body.die()
