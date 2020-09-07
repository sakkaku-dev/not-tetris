extends Node2D

class_name Block

onready var texture := $Texture
onready var collision := $CollisionShape2D
onready var ray_casts := [$BlockCast, $BlockCast2, $BlockCast3, $BlockCast4]
onready var block_size: int = texture.texture.get_height()

func set_color(color: Color) -> void:
	texture.modulate = color

func is_colliding_bottom() -> bool:
	return _is_colliding_with_normal(Vector2.UP)

func is_colliding_left() -> bool:
	return _is_colliding_with_normal(Vector2.RIGHT)
	
func is_colliding_right() -> bool:
	return _is_colliding_with_normal(Vector2.LEFT)
	
func is_colliding_top() -> bool:
	return _is_colliding_with_normal(Vector2.DOWN)

func _is_colliding_with_normal(normal: Vector2) -> bool:
	for cast in ray_casts:
		if cast.is_colliding() and cast.get_collision_normal() == normal:
			return true
	return false

func _get_colliding_cast_normals() -> Array:
	var result = []
	for cast in ray_casts:
		if cast.is_colliding():
			result.append(cast.get_collision_normal())
	return result

func placed() -> void:
	collision.disabled = false
