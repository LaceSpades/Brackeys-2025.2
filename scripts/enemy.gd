extends Area2D
class_name Enemy

@export var _bullet : PackedScene
@onready var warning_timer: Timer = $WarningTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var warning: Sprite2D = $Warning
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var flash_timer: Timer = $FlashTimer
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var hit_marker: Sprite2D = $HitMarker
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var damage_sound: AudioStreamPlayer = $DamageSound

var rng: RandomNumberGenerator;
var health = 2;
var warned_player: bool;

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	
func round_reset() -> void:
	sprite.animation = "idle"
	warning.visible = false
	warned_player = false
	
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
	shoot_sound.play()
	add_child(bullet)
	sprite.animation = "attack"
	bullet.game_manager = get_parent()
	bullet.direction = -1
	bullet.set_collision_layer_value(2, true)
	bullet.set_collision_mask_value(1, true)
	bullet.global_position.x = 282.0
	bullet.global_position.y = 100
	muzzle_flash.visible = true
	warning.visible = false
	warned_player = false
	flash_timer.start()

func die() -> void:
	sprite.self_modulate.a = 0
	await get_tree().create_timer(0.2).timeout
	sprite.self_modulate.a = 1
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate.a = 0
	await get_tree().create_timer(0.05).timeout
	sprite.self_modulate.a = 1
	await get_tree().create_timer(0.25).timeout
	sprite.self_modulate.a = 0
	
func take_damage(amount: int) -> void:
	warning.visible = false
	warned_player = false
	damage_sound.play()
	health -= amount
	hit_marker.visible = true
	get_tree().create_timer(0.1).timeout.connect(Callable(self, "remove_hit_marker"))
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate.a = 0
	await get_tree().create_timer(0.2).timeout
	sprite.self_modulate.a = 1
	
func remove_hit_marker() -> void:
	hit_marker.visible = false

func _on_flash_timer_timeout() -> void:
	muzzle_flash.visible = false
