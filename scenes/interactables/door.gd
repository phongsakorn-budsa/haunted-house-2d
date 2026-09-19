extends StaticBody2D

var is_open: bool = false
var player_node: Node2D = null
var is_mouse_hovering: bool = false

@onready var sprite = $Sprite2D
@onready var solid_collision = $SolidBlock
@onready var label = $Label

func _ready():
	_update_door_state()

func _process(delta):
	# แสดง Label [E] เฉพาะตอนที่ผู้เล่นอยู่ในระยะ และ เอาเมาส์ชี้
	var can_interact = (player_node != null and is_mouse_hovering)
	label.visible = can_interact

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	# เช็คว่ากด E (ครั้งเดียวไม่รัว)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		is_open = !is_open
		_update_door_state()

func _update_door_state():
	if is_open:
		sprite.texture = load("res://assets/door_open.png")
		solid_collision.set_deferred("disabled", true)
	else:
		sprite.texture = load("res://assets/door_close.png")
		solid_collision.set_deferred("disabled", false)

func _on_interact_area_body_entered(body):
	if body.name == "player":
		player_node = body

func _on_interact_area_body_exited(body):
	if body.name == "player":
		player_node = null

func _on_interact_area_mouse_entered():
	is_mouse_hovering = true

func _on_interact_area_mouse_exited():
	is_mouse_hovering = false
