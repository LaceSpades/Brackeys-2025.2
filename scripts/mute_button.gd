extends TextureButton

func _on_pressed() -> void:
	self.texture_normal = load("res://assets/sprites/muted.png") if not Globals.muted else load("res://assets/sprites/unmuted.png")
	Globals.muted = !Globals.muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), Globals.muted)



func _on_ready() -> void:
	self.texture_normal = load("res://assets/sprites/muted.png") if Globals.muted else load("res://assets/sprites/unmuted.png")
