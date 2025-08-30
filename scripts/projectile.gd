extends Area2D
class_name Bullet

var game_manager: GameManager
@onready var sparks: Sprite2D = $Sparks
@onready var sprite_2d: Sprite2D = $Sprite2D
var rng = RandomNumberGenerator.new();

const SPEED = 6000;
var direction = 1
	
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	var hit = area.get_script().get_global_name()
	
	if hit == "Player":
		game_manager.player_hit()
		self.queue_free()
	elif hit == "Enemy":
		game_manager.enemy_hit()
		self.queue_free()
	else:
		game_manager.bullet_hit()
		direction = 0
		sparks.visible = true
		sprite_2d.visible = false
		self.global_position = area.global_position
		self.rotation = rng.randf_range(0, 360)
		await get_tree().create_timer(0.2).timeout
		self.queue_free()
