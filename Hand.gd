extends Node2D

export var grid_path: NodePath
onready var grid: Grid = get_node(grid_path)

const blocks = [
	"res://tetris/I-Shape.tscn",
	"res://tetris/S-Shape.tscn",
	"res://tetris/L-Shape.tscn",
	"res://tetris/J-Shape.tscn",
	"res://tetris/O-Shape.tscn",
	"res://tetris/T-Shape.tscn",
	"res://tetris/Z-Shape.tscn",
]

var block: ShapedBlock

func _ready():
	randomize()
	_spawn_block()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("block_left"):
		block.move_left()
		if block.any_block_invalid(grid):
			block.move_right()
	elif event.is_action_pressed("block_right"):
		block.move_right()
		if block.any_block_invalid(grid):
			block.move_left()
	elif event.is_action_pressed("block_rotate"):
		block.rotate_block()
		if block.any_block_invalid(grid):
			block.rotate_back()
	elif event.is_action_pressed("block_down"):
		move_and_process_block()

func _spawn_block() -> void:
	var block_idx = randi() % blocks.size()
	var shape = load(blocks[block_idx])
	block = shape.instance() as Node2D
	grid.add_child(block)
	
	# add relative position from grid to keep original offset needed for some blocks
	block.global_position -= grid.global_position - global_position
	block.connect("block_placed", self, "place_block")
	print("Spawned")

func place_block() -> void:
	_spawn_block()

func move_and_process_block():
	block.move_down()
	if block.all_blocks_below_grid(grid):
		block.queue_free()
		_spawn_block()
	elif block.any_block_invalid(grid):
		block.move_up()
		grid.put_blocks(block.blocks)
		_spawn_block()
