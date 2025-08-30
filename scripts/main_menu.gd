extends Control

func _on_start_button_pressed() -> void:
	Globals.reset_game()
	if Globals.introduced:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/intro_screen.tscn")


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
