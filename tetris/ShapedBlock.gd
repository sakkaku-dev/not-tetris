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
	self.rotation_degrees += 90
	var block = _get_block_colliding_all()
	if block:
		

func move_down() -> void:
	if not _blocks_on_floor():
		global_translate(Vector2(0, block_size))
	
	if not placed and _blocks_on_floor():
		placed = true
		for block in blocks:
			block.placed()
		emit_signal("block_placed")

func move_left() -> void:
	if not _blocks_colliding_left():
		global_translate(Vector2(-block_size, 0))
		
func move_right() -> void:
	if not _blocks_colliding_right():
		global_translate(Vector2(block_size, 0))

func _blocks_on_floor() -> bool:
	for block in blocks:
		if block.is_colliding_bottom():
			return true
	return false
	
func _blocks_colliding_left() -> bool:
	for block in blocks:
		if block.is_colliding_left():
			return true
	return false

func _blocks_colliding_right() -> bool:
	for block in blocks:
		if block.is_colliding_right():
			return true
	return false

func _get_block_colliding_all() -> Block:
	for block in blocks:
		if block.is_colliding_right() and block.is_colliding_left() and block.is_colliding_bottom() and block.is_colliding_top():
			return block
	return null
