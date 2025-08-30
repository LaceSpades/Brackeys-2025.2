extends Node

var score = 0;
const DEFAULT_PLAYER_LIVES = 5;
var current_player_lives = DEFAULT_PLAYER_LIVES
var safe_modes = ["health_boost", "life_boost"]
var risk_modes = ["enemy_health_boost", "double_lives_lost", "lose_lives", "whos_who_enemy", "whos_who_player", \
	"upside_down"]
var rng = RandomNumberGenerator.new()
var current_mode = "new_game"
var enemy_health = 1;
var life_damage = 1

func reset() -> void:
	reset_player_lives()
	score = 0
	enemy_health = 1
	life_damage = 1

func reset_player_lives() -> void:
	current_player_lives = DEFAULT_PLAYER_LIVES
	
func reset_game() -> void:
	current_mode = "lose_lives"
	
func risk_it(mode: int) -> void:
	if mode == -1:
		current_mode = safe_modes[rng.randi_range(0, safe_modes.size() - 1)]
	elif mode == 0:
		current_mode = "clean"
	else:
		current_mode = risk_modes[rng.randi_range(0, risk_modes.size() - 1)]
