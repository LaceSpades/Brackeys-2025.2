extends Control

func _on_continue_button_pressed() -> void:
	Globals.reset_game()
	Globals.introduced = true;
	get_tree().change_scene_to_file("res://scenes/game.tscn")
