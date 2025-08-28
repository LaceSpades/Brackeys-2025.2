extends Area2D
class_name Bullet

const SPEED = 3000;
var direction = 1
	
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
