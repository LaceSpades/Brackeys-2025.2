extends Node

var score = 0;
var player_lives = 5;
var safe_modes = ["health_boost", "life_boost"]
var risk_modes = ["enemy_health", "double_life_lost", "whos_who_enemy", "whos_who_player", \
	"upside_down"]
var rng = RandomNumberGenerator.new()
var current_mode: String;
	
func risk_it(mode: int) -> void:
	if mode == -1:
		current_mode = safe_modes[rng.randi_range(0, safe_modes.size() - 1)]
	elif mode == 0:
		current_mode = ""
	else:
		current_mode = risk_modes[rng.randi_range(0, risk_modes.size() - 1)]
