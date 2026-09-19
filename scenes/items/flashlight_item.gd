extends Area2D

var player_node: Node2D = null
var is_mouse_hovering: bool = false

func _process(delta):
	# แสดง Label [E] เฉพาะตอนที่ผู้เล่นอยู่ในระยะ และ เอาเมาส์ชี้
	var can_interact = (player_node != null and is_mouse_hovering)
	if has_node("Label"):
		$Label.visible = can_interact
	
	# กด E เพื่อเก็บ
	if can_interact and Input.is_physical_key_pressed(KEY_E):
		if player_node.has_method("pickup_item"):
			player_node.pickup_item("Flashlight")
			queue_free()

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
