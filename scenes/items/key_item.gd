extends Area2D

var player_node: Node2D = null
var is_mouse_hovering: bool = false

@onready var label = $Label

func _process(delta):
	var can_interact = (player_node != null and is_mouse_hovering)
	label.visible = can_interact

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		if player_node.quest_stage >= 1:
			player_node.pickup_key()
			queue_free()
		else:
			print("ต้องรับเควสจาก Hena ก่อนถึงจะเก็บกุญแจได้!")

func _on_body_entered(body):
	if body.name == "player":
		player_node = body

func _on_body_exited(body):
	if body.name == "player":
		player_node = null

func _on_mouse_entered():
	is_mouse_hovering = true

func _on_mouse_exited():
	is_mouse_hovering = false
