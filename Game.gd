extends Node2D

onready var player := $Player
onready var grid := $Grid

var high_score = 0 setget set_high_score

func _process(delta: float) -> void:
	self.high_score = max(_get_player_score_by_position(), high_score)

func _get_player_score_by_position() -> int:
	return floor(abs(player.global_position.y) / grid.cell_size.y) as int

func set_high_score(score: int) -> void:
	var current = high_score
	if score != high_score:
		high_score = score
		print(high_score)
