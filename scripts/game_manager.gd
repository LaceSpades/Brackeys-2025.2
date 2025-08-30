extends Node
class_name GameManager

@export var grey_enemy: PackedScene
@export var red_enemy: PackedScene
@export var blue_enemy: PackedScene
@export var yellow_enemy: PackedScene

@onready var camera: Camera2D = $Camera2D
@onready var player: Player = $Player
@onready var transition: Sprite2D = $Transition
@onready var round_timer: Timer = $RoundTimer
@onready var label: Label = $Label
@onready var label_3: Label = $Label3
var rng = RandomNumberGenerator.new()
var enemies: Array
var current_enemy: Enemy

var enemy_position_x = 759.0
var enemy_position_y = 528.0

var encounter_modifier = 0
var flipped = 1

func _ready() -> void:
	print(Globals.current_mode)
	if Globals.current_mode == "new_game":
		Globals.reset()
	elif Globals.current_mode == "health_boost":
		player.max_health = 2
		player.reset_health()
	elif Globals.current_mode == "life_boost":
		Globals.current_player_lives += 3
	elif Globals.current_mode == "enemy_health_boost":
		Globals.enemy_health = 2
	elif Globals.current_mode == "double_lives_lost":
		Globals.life_damage = 2
	elif Globals.current_mode == "lose_lives":
		Globals.current_player_lives -= 2
		if Globals.current_player_lives < 1:
			Globals.current_player_lives = 1
	elif Globals.current_mode == "upside_down":
		camera.zoom.y = -camera.zoom.y
	elif Globals.current_mode == "flip_sides":
		flipped = -1
		player.position.x = 740
		player.scale.x *= flipped
		enemy_position_x = -750
	elif Globals.current_mode == "more_encounters":
		encounter_modifier = 3
		
	transition.self_modulate.a = 0
	update_score()
	update_lives()
	prepare_run()
	start_encounter()
	
func prepare_run() -> void:
	# Setup multiple encounters in a run
	for n in rng.randi_range(3 + encounter_modifier, 6 + encounter_modifier):
		var enemy_choice = rng.randi_range(0, 3)
		match enemy_choice:
			0:
				enemies.append(grey_enemy.instantiate())
			1:
				enemies.append(red_enemy.instantiate())
			2:
				enemies.append(yellow_enemy.instantiate())
			3:
				enemies.append(blue_enemy.instantiate())
	
func update_score() -> void:
	label.text = str(Globals.score)
	
func update_lives() -> void:
	label_3.text = str(Globals.current_player_lives)
	
func start_encounter() -> void:
	current_enemy = enemies.pop_front()
	current_enemy.position.x = enemy_position_x
	current_enemy.position.y = enemy_position_y
	current_enemy.scale.x *= flipped
	add_child(current_enemy)
	
	start_round()
	
func start_round() -> void:
	current_enemy.round_reset()
	player.round_reset()
	current_enemy.begin_attack()
	
func player_attacks() -> void:
	# Check if enemy has warned
	if not current_enemy.warned_player:
		current_enemy.stop_timers()
		
func player_hit() -> void:
	player.take_damage(1)
	if player.current_health <= 0:
		player.die()
		update_lives()
	
	Globals.score -= 1
	
	end_round()

func enemy_hit() -> void:
	# Punish player for attacking before being warned
	if current_enemy.warned_player:
		Globals.score += 1
	else:
		Globals.score -= 1
	current_enemy.stop_timers()
	
	current_enemy.take_damage(1)
	if current_enemy.current_health <= 0:
		current_enemy.die()
	end_round()
	
func bullet_hit() -> void:
	end_round()
	
func end_round() -> void:
	create_tween().tween_property(transition, "self_modulate:a", 1, 0.5)
	update_score()
	round_timer.start()
			
func end_encounter() -> void:
	if enemies.size() > 0:
		current_enemy.queue_free()
		start_encounter()
	else:
		# Return to risk it menu
		get_tree().call_deferred("change_scene_to_file", "res://scenes/risk_it_menu.tscn")

func _on_round_timer_timeout() -> void:
	transition.self_modulate.a = 0
	
	# Enemy is dead the fight is over
	if current_enemy.current_health <= 0:
		end_encounter()
	elif player.current_health <= 0:
		if Globals.current_player_lives <= 0:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
		else:
			start_round()
	# Someone is still alive
	else:
		# Prepare new round
		start_round()
