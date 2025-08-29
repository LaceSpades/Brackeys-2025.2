extends Node
class_name GameManager

@onready var enemy: Enemy = $Enemy
@onready var player: Player = $Player
@onready var transition: Sprite2D = $Transition
@onready var round_timer: Timer = $RoundTimer
@onready var label: Label = $Label
@onready var label_3: Label = $Label3
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	Globals.reset_player_lives()
	Globals.score = 0
	transition.self_modulate.a = 0
	update_score()
	update_lives()
	start_round()
	
func prepare_run() -> void:
	# Setup multiple encounters in a run
	for n in rng.randi_range(3, 6):
		pass
	
func update_score() -> void:
	label.text = str(Globals.score)
	
func update_lives() -> void:
	label_3.text = str(Globals.player_lives)
	
func start_round() -> void:
	enemy.begin_attack()
	
func player_attacks() -> void:
	# Check if enemy has warned
	if not enemy.warned_player:
		enemy.stop_timers()
		
func player_hit() -> void:
	player.health -= 1
	if player.health <= 0:
		player.die()
		update_lives()
	
	Globals.score -= 1
	
	end_round()

func enemy_hit() -> void:
	# Punish player for attacking before being warned
	if enemy.warned_player:
		Globals.score += 1
	else:
		Globals.score -= 1
	enemy.stop_timers()
	
	enemy.health -= 1
	if enemy.health <= 0:
		enemy.die()
	
	end_round()
	
func bullet_hit() -> void:
	end_round()
	
func end_round() -> void:
	create_tween().tween_property(transition, "self_modulate:a", 1, 0.5)
	update_score()
	round_timer.start()
			
func end_encounter() -> void:
	# TODO Don't immediatly reset scene
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")

func _on_round_timer_timeout() -> void:
	# Enemy is dead the fight is over
	if enemy.health <= 0:
		end_encounter()
	elif player.health <= 0:
		if Globals.player_lives <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
		else:
			start_round()
	# Someone is still alive
	else:
		# Prepare new round
		start_round()
	
	player.round_reset()
	enemy.round_reset()
	transition.self_modulate.a = 0
