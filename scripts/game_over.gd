extends Control

func _on_restart_pressed() -> void:
	Globals.reset_game()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
 
func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
