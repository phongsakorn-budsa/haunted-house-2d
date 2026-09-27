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
	var can_interact = (player_node != null and is_mouse_hovering and not is_open)
	if can_interact:
		if player_node.quest_stage < 4:
			label.text = "[ นำกุญแจ 3 ดอกไปให้ Hena ก่อน ]"
		else:
			label.text = "[E] เปิดประตู Lab"
	label.visible = can_interact

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		if player_node.quest_stage >= 4 and not is_open:
			is_open = true
			_update_door_state()
			
			var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
			var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
			if dialog and dialog_label:
				dialog_label.text = "Player: ประตูเปิดแล้ว! เข้าไปล่ามอนสเตอร์กันเถอะ..."
				dialog.visible = true
				await get_tree().create_timer(3.0).timeout
				dialog.visible = false

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