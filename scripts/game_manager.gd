extends Node
class_name GameManager

@export var grey_enemy: PackedScene
@export var red_enemy: PackedScene
@export var blue_enemy: PackedScene
@export var yellow_enemy: PackedScene
@export var player_sus: PackedScene
@export var enemy_sus: PackedScene

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

var normal_player_pos_x = -760
var normal_player_pos_y = 531

var encounter_modifier = 0
var score_modifier = 0
var flipped = 1

const BLOCK_VALUE = 3
const DAMAGE_VALUE = 1
const HIT_VALUE = 2
const JUMP_WARNING = 3

func _ready() -> void:
	if Globals.current_mode == "new_game":
		Globals.reset()
	elif Globals.current_mode == "health_boost":
		player.max_health = 2
		score_modifier -= 1
		player.reset_health()
	elif Globals.current_mode == "life_boost":
		Globals.current_player_lives += 3
		score_modifier -= 1
	elif Globals.current_mode == "enemy_health_boost":
		Globals.enemy_health = 2
		score_modifier += 1
	elif Globals.current_mode == "double_lives_lost":
		Globals.life_damage = 2
		score_modifier += 1
	elif Globals.current_mode == "lose_lives":
		score_modifier += 1
		Globals.current_player_lives -= 2
		if Globals.current_player_lives < 1:
			Globals.current_player_lives = 1
	elif Globals.current_mode == "upside_down":
		score_modifier += 1
		camera.zoom.y = -camera.zoom.y
	elif Globals.current_mode == "flip_sides":
		score_modifier += 1
		flipped = -1
		player.position.x = 740
		player.scale.x *= flipped
		enemy_position_x = -750
	elif Globals.current_mode == "more_encounters":
		score_modifier += 1
		encounter_modifier = 3
	elif Globals.current_mode == "whos_who_enemy":
		score_modifier += 2
		var temp_player = player_sus.instantiate()
		add_child(temp_player)
		temp_player.position.x = player.position.x
		temp_player.position.y = player.position.y
		player.queue_free()
		player = temp_player
		temp_player.game_manager = self
	elif Globals.current_mode == "whos_who_player":
		score_modifier += 2
	elif Globals.current_mode == "reduce_score":
		score_modifier += 1
		Globals.score = Globals.score - (abs(Globals.score)/2)

	transition.self_modulate.a = 0
	update_score()
	update_lives()
	prepare_run()
	start_encounter()
	
func prepare_run() -> void:
	# Setup multiple encounters in a run
	for n in rng.randi_range(3 + encounter_modifier, 6 + encounter_modifier):
		if Globals.current_mode != "whos_who_player":
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
		else:
			enemies.append(enemy_sus.instantiate())
	
func update_score() -> void:
	label.text = str(Globals.score)
	
func update_lives() -> void:
	if Globals.current_player_lives < 0:
		Globals.current_player_lives = 0
	label_3.text = str(Globals.current_player_lives)
	
func start_encounter() -> void:
	current_enemy = enemies.pop_front()
	current_enemy.position.y = enemy_position_y
	if Globals.current_mode == "whos_who_player" or Globals.current_mode == "whos_who_enemy":
		var sides = rng.randi_range(0, 1)
		# Normal
		if sides == 0:
			player.position.x = normal_player_pos_x
			player.scale.x = 1
			current_enemy.position.x = enemy_position_x
			current_enemy.scale.x = 1
		# Flipped
		else:
			player.position.x = enemy_position_x
			player.scale.x = -1
			current_enemy.position.x = normal_player_pos_x
			current_enemy.scale.x = -1
	else:
		current_enemy.position.x = enemy_position_x
		current_enemy.scale.x *= flipped
	add_child(current_enemy)
	
	start_round()
	
func start_round() -> void:
	current_enemy.round_reset()
	player.round_reset()
	current_enemy.begin_attack()
	
func can_player_attack() -> bool:
	return current_enemy.warned_player
	
func player_attacks() -> void:
	# Check if enemy has warned
	if not current_enemy.warned_player:
		current_enemy.stop_timers()
		current_enemy.fire()
		current_enemy.flash_shield()

func player_hit() -> void:
	player.take_damage(1)
	if player.current_health <= 0:
		player.die()
		update_lives()
	
	Globals.score -= (DAMAGE_VALUE + score_modifier)
	
	end_round()

func enemy_hit() -> void:
	# Punish player for attacking before being warned
	if current_enemy.warned_player:
		Globals.score += (HIT_VALUE + score_modifier)
		current_enemy.take_damage(1)
		if current_enemy.current_health <= 0:
			current_enemy.die()
	else:
		player_hit()
	current_enemy.stop_timers()
	end_round()
	
func bullet_hit() -> void:
	Globals.score += (BLOCK_VALUE + score_modifier)
	end_round()
	
func end_round() -> void:
	create_tween().tween_property(transition, "self_modulate:a", 1, 0.5)
	update_score()
	round_timer.start()
			
func end_encounter() -> void:
	if Globals.current_player_lives <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
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
