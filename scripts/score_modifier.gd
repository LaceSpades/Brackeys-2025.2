extends Label


func _on_ready() -> void:
	text = str(Globals.score_modifier) + "x Score Modifier"
