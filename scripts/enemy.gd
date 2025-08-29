extends Area2D
class_name Enemy

@export var _bullet : PackedScene
@onready var warning_timer: Timer = $WarningTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var warning: Sprite2D = $Warning
@onready var sprite: AnimatedSprite2D = $Sprite

var rng: RandomNumberGenerator;
var health = 2;
var warned_player: bool;

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	
func round_reset() -> void:
	warning.visible = false
	warned_player = false
	sprite.animation = "idle"
	
func reset() -> void:
	health = 1

func stop_timers() -> void:
	warning_timer.stop()
	attack_timer.stop()
	
func begin_attack() -> void:
	# Warn player before attack begins
	warning_timer.wait_time = rng.randf_range(0.5, 2)
	warning_timer.start()

func _on_timer_timeout() -> void:
	# Wait until attacking the player
	warned_player = true
	attack_timer.wait_time = rng.randf_range(0.25, 1)
	attack_timer.start()
	warning.visible = true

func _on_attack_timer_timeout() -> void:
	# Spawn bullet to attack player
	var bullet : Bullet = _bullet.instantiate()
	add_child(bullet)
	sprite.animation = "attack"
	bullet.game_manager = get_parent()
	bullet.direction = -1
	bullet.set_collision_layer_value(2, true)
	bullet.set_collision_mask_value(1, true)

func die() -> void:
	sprite.rotation = 90
