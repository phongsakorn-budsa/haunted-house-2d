import io
with io.open('scenes/player/player.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Update quest stages UI
quest_ui_code = '''func update_quest_ui():
	var quest_label = get_tree().current_scene.get_node_or_null("UI/QuestLabel")
	if quest_label:
		if quest_stage == 0:
			quest_label.text = "ภารกิจ: คุยกับ Hena"
		elif quest_stage == 1:
			quest_label.text = "ภารกิจ: คุยกับ Hena อีกครั้งเพื่อหาทางออก"
		elif quest_stage == 2:
			quest_label.text = "ภารกิจ: หากุญแจ (" + str(keys_collected) + "/3)"
		elif quest_stage == 3:
			quest_label.text = "ภารกิจ: นำกุญแจ 3 ดอกกลับไปให้ Hena"
		elif quest_stage == 4:
			if ingredients_collected < 3: # Actually this is obsolete, we use has_item now, but keep for label logic
				quest_label.text = "ภารกิจ: เปิดห้องวิจัย (Lab Door) และล่าหาส่วนผสม (3 อย่าง)"
			else:
				quest_label.text = "ภารกิจ: นำส่วนผสมไปที่เครื่องผสมยา"
		elif quest_stage == 5:
			quest_label.text = "ภารกิจ: นำ Revival Potion กลับไปให้ Hena!"
		elif quest_stage == 6:
			quest_label.text = "ภารกิจ: กำจัดปีศาจ Hena!!"
'''

# We need to replace the old update_quest_ui block
start_idx = content.find('func update_quest_ui():')
end_idx = content.find('func _physics_process(delta):')

if start_idx != -1 and end_idx != -1:
    content = content[:start_idx] + quest_ui_code + '\n' + content[end_idx:]

with io.open('scenes/player/player.gd', 'w', encoding='utf-8') as f:
    f.write(content)