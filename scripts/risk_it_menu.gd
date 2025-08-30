extends Control

func _on_retire_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_play_it_safe_pressed() -> void:
	Globals.risk_it(-1)
	return_to_game()

func _on_keep_going_pressed() -> void:
	Globals.risk_it(0)
	return_to_game()

func _on_risk_it_button_pressed() -> void:
	Globals.risk_it(1)
	return_to_game()
	
func return_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
