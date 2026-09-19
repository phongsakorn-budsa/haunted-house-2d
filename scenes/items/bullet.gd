extends Area2D

const SPEED = 800.0
var direction = Vector2.ZERO
var damage = 1

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.name == "player":
		return
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	queue_free()

func _on_timer_timeout():
	queue_free()
