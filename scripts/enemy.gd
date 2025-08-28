extends Area2D

@onready var game_manager: GameManager = %GameManager
@export var _bullet : PackedScene

var shot: bool;

func _process(delta: float) -> void:
	if game_manager.round_begun and not shot:
		var bullet : Bullet = _bullet.instantiate()
		add_child(bullet)
		bullet.direction = -1
		bullet.set_collision_layer_value(2, true)
		bullet.set_collision_mask_value(1, true)
		shot = true
