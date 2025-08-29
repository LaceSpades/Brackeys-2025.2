extends Area2D
class_name Bullet

var game_manager: GameManager

const SPEED = 4000;
var direction = 1
	
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	var hit = area.get_script().get_global_name()
	
	if hit == "Player":
		game_manager.player_hit()
	elif hit == "Enemy":
		game_manager.enemy_hit()
	else:
		area.queue_free()
		game_manager.bullet_hit()
