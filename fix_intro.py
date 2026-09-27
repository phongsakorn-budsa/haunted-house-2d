import io
with io.open('scenes/interactables/hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add _ready and auto_intro
ready_block = '''
func _ready():
	# รอให้ฉากโหลดเสร็จก่อนค่อยเริ่มบทสนทนา
	call_deferred("_start_intro")

func _start_intro():
	var p = get_tree().current_scene.get_node_or_null("player")
	if p and p.quest_stage == 0:
		is_talking = true
		await show_text("Player: โอ้ย เจ็บจัง ฉันอยู่ที่ไหนเนี่ยยย", 3.0)
		await show_text("Hena: ไง นายโอเคไหม นายกำลังอยู่ในปราสาทที่ไหนสักที่หนึ่ง\\nนายโดนจับตัวมาหนะ ฉันก็ด้วยย", 4.0)
		await show_text("Player: ฉันจะออกจากที่นี่ได้ยังไง", 3.0)
		await show_text("Hena: ฉันรู้นะแต่ฉันเจ็บขามาก ในปราสาทนี้พวกมันมีอยู่เต็มไปหมด\\nนายพักก่อน ถ้านายอยากออกเมื่อไหร่ ค่อยมาคุยกับฉัน", 5.0)
		if is_instance_valid(p):
			p.quest_stage = 1
			p.update_quest_ui()
		var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
		if dialog_box:
			dialog_box.visible = false
		is_talking = false

'''

content = content.replace('func _process(delta):', ready_block + 'func _process(delta):')

# 2. Remove quest_stage == 0 from talk_to_player
old_talk = '''	if p.quest_stage == 0:
		await show_text("Player: โอ้ย เจ็บจัง ฉันอยู่ที่ไหนเนี่ยยย", 3.0)
		await show_text("Hena: ไง นายโอเคไหม นายกำลังอยู่ในปราสาทที่ไหนสักที่หนึ่ง\\nนายโดนจับตัวมาหนะ ฉันก็ด้วยย", 4.0)
		await show_text("Player: ฉันจะออกจากที่นี่ได้ยังไง", 3.0)
		await show_text("Hena: ฉันรู้นะแต่ฉันเจ็บขามาก ในปราสาทนี้พวกมันมีอยู่เต็มไปหมด\\nนายพักก่อน ถ้านายอยากออกเมื่อไหร่ ค่อยมาคุยกับฉัน", 5.0)
		if is_instance_valid(p):
			p.quest_stage = 1
			p.update_quest_ui()
	elif p.quest_stage == 1:'''

new_talk = '''	if p.quest_stage == 1:'''

content = content.replace(old_talk, new_talk)

with io.open('scenes/interactables/hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)