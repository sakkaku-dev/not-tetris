extends Node2D

const blocks = ["res://tetris/I-Shape.tscn", "res://tetris/S-Shape.tscn"]
var block

func _ready():
	randomize()
	_spawn_block()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("block_left"):
		block.move_left()
	elif event.is_action_pressed("block_right"):
		block.move_right()
	elif event.is_action_pressed("block_rotate"):
		block.rotate_block()

func _spawn_block() -> void:
	var block_idx = randi() % blocks.size()
	var shape = load(blocks[block_idx])
	block = shape.instance() as Node2D
	add_child(block)
	block.connect("block_placed", self, "place_block")

func place_block() -> void:
	_spawn_block()

func _on_Timer_timeout():
	block.move_down()
