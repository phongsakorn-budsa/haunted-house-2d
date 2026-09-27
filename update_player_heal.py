import io
import re

with io.open('scenes/player/player.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Add heal_to_full function before update_quest_ui
heal_func = '''func heal_to_full():
	health = 3
	ammo = MAX_AMMO
	is_reloading = false
	update_ammo_ui()
	
	var health_ui = get_tree().current_scene.get_node_or_null("UI/HealthUI")
	if health_ui:
		var hearts = health_ui.get_children()
		for i in range(hearts.size()):
			hearts[i].visible = (i < health)

func update_quest_ui():
	heal_to_full() # ฮีลเลือดและเติมกระสุนเต็มเมื่อเควสเปลี่ยน
'''
content = content.replace('func update_quest_ui():\n', heal_func)

with io.open('scenes/player/player.gd', 'w', encoding='utf-8') as f:
    f.write(content)