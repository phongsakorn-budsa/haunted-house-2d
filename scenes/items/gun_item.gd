extends Area2D

var can_pickup = false
var player_node = null

func _input(event):
	if can_pickup and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		if player_node and player_node.has_method("pickup_gun"):
			player_node.pickup_gun()
			queue_free()

func _on_body_entered(body):
	if body.name == "player":
		can_pickup = true
		player_node = body

func _on_body_exited(body):
	if body.name == "player":
		can_pickup = false
		player_node = null
