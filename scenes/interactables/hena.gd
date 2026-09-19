extends StaticBody2D

var player_node: Node2D = null
var is_mouse_hovering: bool = false
var is_talking: bool = false

@onready var label = $Label

func _process(delta):
	var can_interact = (player_node != null and is_mouse_hovering)
	label.visible = can_interact and not is_talking

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		talk_to_player()

func talk_to_player():
	if is_talking: return
	var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	
	if dialog_box and dialog_label:
		is_talking = true
		dialog_box.visible = true
		
		if player_node.quest_stage == 0:
			dialog_label.text = "Hena: ถ้านายอยากออกจากที่นี่ จงตามหากุญแจ 3 ดอก มันจะอยู่ในปราสาทนี้..."
			player_node.quest_stage = 1
			player_node.update_quest_ui()
		elif player_node.quest_stage == 1:
			dialog_label.text = "Hena: รีบไปหากุญแจสิ! ต้องใช้ตั้ง 3 ดอกนะ (" + str(player_node.keys_collected) + "/3)"
		elif player_node.quest_stage == 2:
			dialog_label.text = "Hena: ยอดเยี่ยมมาก! นายเจอกุญแจครบ 3 ดอกแล้ว! ทางออกเปิดออกแล้ว!"
			player_node.quest_stage = 3
			player_node.update_quest_ui()
		elif player_node.quest_stage == 3:
			dialog_label.text = "Hena: โชคดีนะ หวังว่าจะได้พบกันอีก..."
			
		# หน่วงเวลาแล้วปิดกรอบข้อความ
		await get_tree().create_timer(3.5).timeout
		dialog_box.visible = false
		is_talking = false

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
