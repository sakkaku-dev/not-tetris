extends KinematicBody2D

class_name Player

signal died

export var speed = 50
export var jump = -50

export var grid_path: NodePath
onready var grid: Grid = get_node(grid_path)

onready var head_cast := $HeadCast
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * ProjectSettings.get_setting("physics/2d/default_gravity_vector")

var velocity = Vector2.ZERO
var side_motion = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
		_update_input()

func _update_input() -> void:
	if Input.is_action_pressed("move_left"):
		side_motion = -1
		head_cast.rotation_degrees = 90
	elif Input.is_action_pressed("move_right"):
		side_motion = 1
		head_cast.rotation_degrees = -90
		
func _has_input() -> bool:
	return Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func _physics_process(delta: float) -> void:
	if not _has_input():
		side_motion = 0
	
	if not head_cast.is_colliding() and is_on_wall() and is_on_floor():
		velocity.y = jump
	
	if grid.is_below_grid(global_position):
		die()
	
	velocity.x = side_motion * speed
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func die() -> void:
	hide() # Do not remove player, still needed by other nodes
	emit_signal("died")
