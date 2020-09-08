extends Node2D

onready var player := $Player
onready var grid := $Grid
onready var high_score_label := $CameraStepFollow/UI/HighScore
onready var info_label := $CameraStepFollow/UI/Info
onready var game_tick := $GameTick

var last_tick_increase = 0
var high_score = 0 setget set_high_score
var game_over = false
	
func _ready():
	high_score_label.text = str(high_score)
	
func _input(event: InputEvent) -> void:
	if game_over:
		if event.is_action_pressed("ui_select"):
			get_tree().change_scene("res://Main.tscn")
		get_tree().set_input_as_handled()

func _process(delta: float) -> void:
	if game_over: return

	self.high_score = max(_get_player_score_by_position(), high_score)
	if high_score % 10 == 0 and high_score > 1 and last_tick_increase != high_score and game_tick.wait_time > .2:
		game_tick.wait_time -= .1
		last_tick_increase = high_score

func _get_player_score_by_position() -> int:
	return floor(abs(player.global_position.y) / grid.cell_size.y) as int

func set_high_score(score: int) -> void:
	var current = high_score
	if score != high_score:
		high_score = score
		high_score_label.text = str(high_score)

func game_over():
	print("Game Over")
	game_over = true
	info_label.show()
	game_tick.stop()
