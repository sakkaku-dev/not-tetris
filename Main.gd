extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		get_tree().change_scene("res://Game.tscn")
