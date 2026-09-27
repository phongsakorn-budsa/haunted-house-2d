import io
with io.open('scenes/interactables/ingredient_mixer.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Add target_visual_size variable
content = content.replace('var mixer_stage = 0\n', 'var mixer_stage = 0\nvar target_visual_size = Vector2.ZERO\n')

# Add capture in _ready
ready_old = '''func _ready():
	if has_node("InteractArea"):'''
ready_new = '''func _ready():
	if has_node("Sprite2D") and .texture:
		target_visual_size = .texture.get_size() * .scale
	if has_node("InteractArea"):'''
content = content.replace(ready_old, ready_new)

# Add set_mixer_texture function
helper = '''func set_mixer_texture(path: String):
	if has_node("Sprite2D"):
		var new_tex = load(path)
		if new_tex:
			.texture = new_tex
			if target_visual_size != Vector2.ZERO:
				var tex_size = new_tex.get_size()
				if tex_size.x > 0 and tex_size.y > 0:
					.scale = Vector2(target_visual_size.x / tex_size.x, target_visual_size.y / tex_size.y)
'''
content = content + "\n" + helper

# Replace texture assignments
content = content.replace('.texture = load("res://assets/Ingredientmixer_LifeHerb.png")', 'set_mixer_texture("res://assets/Ingredientmixer_LifeHerb.png")')
content = content.replace('.texture = load("res://assets/Ingredientmixer_LifeHerb_Mushroom.png")', 'set_mixer_texture("res://assets/Ingredientmixer_LifeHerb_Mushroom.png")')
content = content.replace('.texture = load("res://assets/Ingredientmixer_LifeHerb_Mushroom_Crystal.png")', 'set_mixer_texture("res://assets/Ingredientmixer_LifeHerb_Mushroom_Crystal.png")')
content = content.replace('.texture = load("res://assets/Ingredientmixer.png")', 'set_mixer_texture("res://assets/Ingredientmixer.png")')
content = content.replace('.texture = load("res://assets/Ingredientmixer_running" + str(anim_frame) + ".png")', 'set_mixer_texture("res://assets/Ingredientmixer_running" + str(anim_frame) + ".png")')

with io.open('scenes/interactables/ingredient_mixer.gd', 'w', encoding='utf-8') as f:
    f.write(content)