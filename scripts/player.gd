extends Area2D
class_name Player

@export var _bullet : PackedScene
@export var game_manager: GameManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var shot: bool;
var health = 1;

func round_reset() -> void:
	shot = false
	health = 1
	animated_sprite_2d.rotation = 0
	animated_sprite_2d.animation = "idle"

func reset() -> void:
	shot = false
	health = 1

func _process(delta: float) -> void:
	if health > 0:
		if Input.is_action_just_pressed("interact") and not shot:
			var bullet : Bullet = _bullet.instantiate()
			add_child(bullet)
			bullet.direction = 1
			bullet.set_collision_layer_value(1, true)
			bullet.set_collision_mask_value(2, true)
			bullet.game_manager = game_manager
			shot = true
			animated_sprite_2d.animation = "attack"
			game_manager.player_attacks()
		
func die() -> void:
	animated_sprite_2d.rotation = -90
	Globals.player_lives -= 1
