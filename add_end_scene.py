import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_die = '''func die():
	is_dead = true
	sprite.texture = load("res://assets/hena_demon.png") # กลับเป็นท่ายืนนิ่ง
	health_bar.visible = false
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog and dialog_label:
		dialog_label.text = "Victory! ภารกิจสำเร็จ คุณรอดชีวิตแล้ว!"
		dialog.visible = true
	
	queue_free()'''

new_die = '''func die():
	is_dead = true
	sprite.texture = load("res://assets/hena_demon.png") # กลับเป็นท่ายืนนิ่ง
	health_bar.visible = false
	
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)
	await show_text("Player: ฉันไปแล้ว ฉันกลัวแล้ว ไม่เอาแล้วว ไปอยู่บ้านเฉยๆ ก็ดีแล้ว", 4.0)
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog:
		dialog.visible = false
		
	# วาร์ปไปหน้าจบเกม
	get_tree().change_scene_to_file("res://scenes/ui/chapter_end.tscn")
	queue_free()'''

content = content.replace(old_die, new_die)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)