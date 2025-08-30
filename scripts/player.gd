extends Area2D
class_name Player

@export var _bullet : PackedScene
@export var game_manager: GameManager
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var flash_timer: Timer = $FlashTimer
@onready var hit_marker: Sprite2D = $HitMarker

var shot: bool;
var health = 1;

func round_reset() -> void:
	shot = false
	health = 1
	sprite.self_modulate.a = 1
	sprite.animation = "idle"

func reset() -> void:
	shot = false
	health = 1

func _process(delta: float) -> void:
	if health > 0:
		if Input.is_action_just_pressed("interact") and not shot:
			# Create a bullet
			var bullet : Bullet = _bullet.instantiate()
			add_child(bullet)
			bullet.direction = 1
			bullet.set_collision_layer_value(1, true)
			bullet.set_collision_mask_value(2, true)
			bullet.game_manager = game_manager
			bullet.global_position.x = -406.0
			bullet.global_position.y = 126.0
			
			muzzle_flash.visible = true
			flash_timer.start()
			shot = true
			sprite.animation = "attack"
			game_manager.player_attacks()
		
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
	Globals.player_lives -= 1
	
func take_damage(amount: int) -> void:
	health -= amount
	sprite.self_modulate.a = 0
	hit_marker.visible = true
	get_tree().create_timer(0.1).timeout.connect(Callable(self, "remove_hit_marker"))
	await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.2).timeout
	sprite.self_modulate.a = 1
	
func remove_hit_marker() -> void:
	hit_marker.visible = false

func _on_flash_timer_timeout() -> void:
	muzzle_flash.visible = false
