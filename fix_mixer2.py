import io
content = '''extends Area2D

var player_node = null
var is_mouse_hovering = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	is_mouse_hovering = true

func _on_mouse_exited():
	is_mouse_hovering = false

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		if player_node.quest_stage == 4 and player_node.ingredients_collected >= 3:
			player_node.quest_stage = 5
			player_node.update_quest_ui()
			
			var inventory_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
			if inventory_ui:
				inventory_ui.remove_item("Life_Herb")
				inventory_ui.remove_item("SoulCrystal")
				inventory_ui.remove_item("BloodmoonMushroom")
				inventory_ui.add_item("RevivalPotion")
			
			var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
			var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
			if dialog and dialog_label:
				dialog_label.text = "ผสมยาสำเร็จ! ได้ Revival Potion มาแล้ว รีบเอาไปให้ Hena เถอะ!"
				dialog.visible = true
				await get_tree().create_timer(3.0).timeout
				dialog.visible = false

func _on_body_entered(body):
	if body.name == "player":
		player_node = body

func _on_body_exited(body):
	if body.name == "player":
		player_node = null
'''

with io.open('scenes/interactables/ingredient_mixer.gd', 'w', encoding='utf-8') as f:
    f.write(content)