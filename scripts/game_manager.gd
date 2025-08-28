extends Node
class_name GameManager

var score = 0;
var round_begun = false;

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()
	
func _on_timer_timeout() -> void:
	round_begun = true
