import io
with io.open('scenes/interactables/hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_boss_logic = '''		# กลายร่างสมบูรณ์เป็นรูปสุดท้าย
		is_transforming = false
		set_hena_texture("res://assets/hena_tranferdemon3.png")
		await show_text("Hena: ฮ่าๆๆๆ ตายซะ!!", 3.0)
		
		if is_instance_valid(p):
			p.quest_stage = 6
			p.update_quest_ui()
	elif p.quest_stage == 6:
		await show_text("Hena: ฮ่าๆๆๆ ตายซะ!!", 2.0)
		
	var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog_box:
		dialog_box.visible = false
	is_talking = false'''

new_boss_logic = '''		# กลายร่างสมบูรณ์เป็นรูปสุดท้าย
		is_transforming = false
		set_hena_texture("res://assets/hena_demon.png")
		await show_text("Hena: ฮ่าๆๆๆ ตายซะ!!", 3.0)
		
		var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
		if dialog_box:
			dialog_box.visible = false
			
		# ทำจอมืด (Fade to black)
		var canvas = CanvasLayer.new()
		canvas.layer = 100
		get_tree().current_scene.add_child(canvas)
		
		var fade = ColorRect.new()
		fade.color = Color(0, 0, 0, 0)
		fade.set_anchors_preset(Control.PRESET_FULL_RECT)
		canvas.add_child(fade)
		
		var tween = get_tree().create_tween()
		tween.tween_property(fade, "color:a", 1.0, 2.0) # เฟดเป็นสีดำใน 2 วินาที
		await tween.finished
		
		# เปลี่ยนฉากไปที่ห้องบอส
		get_tree().change_scene_to_file("res://boss_room.tscn")
		
	elif p.quest_stage == 6:
		pass
		
	var dbox = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dbox and p.quest_stage != 5:
		dbox.visible = false
	is_talking = false'''

content = content.replace(old_boss_logic, new_boss_logic)

with io.open('scenes/interactables/hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)