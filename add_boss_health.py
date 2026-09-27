import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Add health_bar variable
content = content.replace('var intro_done = false\n', 'var intro_done = false\nvar health_bar = ProgressBar.new()\n')

# Setup health bar in _ready
old_ready = '''func _ready():
	add_to_group("enemies")
	player_node = get_tree().current_scene.get_node_or_null("player")'''

new_ready = '''func _ready():
	add_to_group("enemies")
	player_node = get_tree().current_scene.get_node_or_null("player")
	
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.size = Vector2(120, 15)
	health_bar.position = Vector2(-60, -180)
	health_bar.show_percentage = false
	health_bar.modulate = Color(1, 0, 0)
	health_bar.visible = false
	add_child(health_bar)'''

content = content.replace(old_ready, new_ready)

# Show health bar after intro
old_intro = '''	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog:
		dialog.visible = false
		
	intro_done = true'''

new_intro = '''	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog:
		dialog.visible = false
		
	intro_done = true
	health_bar.visible = true'''

content = content.replace(old_intro, new_intro)

# Update health bar in take_damage
old_dmg = '''func take_damage(amount):
	if is_dead or not intro_done: return
	health -= amount'''

new_dmg = '''func take_damage(amount):
	if is_dead or not intro_done: return
	health -= amount
	health_bar.value = health'''

content = content.replace(old_dmg, new_dmg)

# Hide health bar on death
old_die = '''func die():
	is_dead = true
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)'''

new_die = '''func die():
	is_dead = true
	health_bar.visible = false
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)'''

content = content.replace(old_die, new_die)


with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)