extends Control

@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var press_sound: AudioStreamPlayer = $PressSound

func _on_pressed() -> void:
	press_sound.play()

func _on_mouse_entered() -> void:
	hover_sound.play()
