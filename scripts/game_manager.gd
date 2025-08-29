extends Node
class_name GameManager

@onready var enemy: Enemy = $Enemy
@onready var player: Player = $Player
@onready var transition: Sprite2D = $Transition
@onready var round_timer: Timer = $RoundTimer
@onready var label: Label = $Label

func _ready() -> void:
	transition.self_modulate.a = 0
	update_score()
	start_round()
	
func update_score() -> void:
	label.text = "Score: " + str(Globals.score)
	
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
	player.round_reset()
	enemy.round_reset()
	create_tween().tween_property(transition, "self_modulate:a", 1, 0.5)
	update_score()
	round_timer.start()
			
func end_fight() -> void:
	get_tree().call_deferred("reload_current_scene")

func _on_round_timer_timeout() -> void:
	# Player or Enemy is dead, fight is over
	if player.health <= 0 or enemy.health <= 0:
		end_fight()
	# Someone is still alive
	else:
		# Prepare new round
		start_round()
		
	transition.self_modulate.a = 0
