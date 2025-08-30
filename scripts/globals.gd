extends Node

var score = 0;
const DEFAULT_PLAYER_LIVES = 5;
var current_player_lives = DEFAULT_PLAYER_LIVES
var safe_modes = ["health_boost", "life_boost"]
var risk_modes = ["enemy_health", "double_lives_lost", "lose_lives", "whos_who_enemy", "whos_who_player", \
	"upside_down"]
var rng = RandomNumberGenerator.new()
var current_mode = "new_game"

func reset_player_lives() -> void:
	current_player_lives = DEFAULT_PLAYER_LIVES
	
func reset_game() -> void:
	current_mode = "new_game"
	
func risk_it(mode: int) -> void:
	if mode == -1:
		current_mode = safe_modes[rng.randi_range(0, safe_modes.size() - 1)]
	elif mode == 0:
		current_mode = "clean"
	else:
		current_mode = risk_modes[rng.randi_range(0, risk_modes.size() - 1)]
