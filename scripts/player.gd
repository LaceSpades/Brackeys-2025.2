extends Area2D

@export var _bullet : PackedScene
@onready var game_manager: GameManager = %GameManager

var shot: bool;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and game_manager.round_begun and not shot:
		var bullet : Bullet = _bullet.instantiate()
		add_child(bullet)
		bullet.direction = 1
		bullet.set_collision_layer_value(1, true)
		bullet.set_collision_mask_value(2, true)
		shot = true
