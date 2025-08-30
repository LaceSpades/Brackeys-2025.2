extends Control

@onready var display_timer: Timer = $DisplayTimer
@onready var mode: Label = $Mode
@onready var play_it_safe: Button = $PlayItSafe
@onready var keep_going: Button = $KeepGoing
@onready var risk_it: Button = $RiskIt
@onready var retire: Button = $Retire

func _on_retire_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func disable_buttons() -> void:
	play_it_safe.disabled = true
	keep_going.disabled = true
	risk_it.disabled = true
	retire.disabled = true
	display_timer.start()

func _on_play_it_safe_pressed() -> void:
	Globals.risk_it(-1)
	display_mode()
	disable_buttons()
	
func _on_keep_going_pressed() -> void:
	Globals.risk_it(0)

func _on_risk_it_pressed() -> void:
	Globals.risk_it(1)
	display_mode()
	disable_buttons()
	
func display_mode() -> void:
	mode.text = Globals.current_mode
	
func _on_display_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
