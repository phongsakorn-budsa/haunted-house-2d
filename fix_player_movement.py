import io
with io.open('scenes/player/player.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Block movement
old_phys = '''func _physics_process(delta):
	if is_dead: return
	
	var direction = Vector2.ZERO'''

new_phys = '''func _physics_process(delta):
	if is_dead: return
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog and dialog.visible:
		.play("idle")
		if has_node("WeaponPivot/GunSprite"):
			/GunSprite.play("idle")
		return
		
	var direction = Vector2.ZERO'''

content = content.replace(old_phys, new_phys)

# 2. Block shooting
old_shoot = '''func shoot():
	if not has_gun or not has_node("WeaponPivot/GunSprite"): return
	if ammo <= 0 or is_reloading: return'''

new_shoot = '''func shoot():
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog and dialog.visible: return
	if not has_gun or not has_node("WeaponPivot/GunSprite"): return
	if ammo <= 0 or is_reloading: return'''

content = content.replace(old_shoot, new_shoot)

with io.open('scenes/player/player.gd', 'w', encoding='utf-8') as f:
    f.write(content)