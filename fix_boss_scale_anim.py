import io
import re

with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Add Smart Scale variables
content = content.replace('var is_attacking = false\n', 'var is_attacking = false\nvar target_visual_size = Vector2.ZERO\n')

# Add Smart Scale calculation in _ready
ready_addition = '''	.wait_time = 1.0
	
	if sprite.texture:
		target_visual_size = sprite.texture.get_size() * sprite.scale
	else:
		var t = load("res://assets/hena_demon.png")
		target_visual_size = t.get_size() * sprite.scale'''
content = content.replace('\t.wait_time = 1.0', ready_addition)

# Add set_hena_texture function
set_texture_func = '''
func set_hena_texture(path: String):
	var tex = load(path)
	if tex:
		sprite.texture = tex
		var new_size = tex.get_size()
		if new_size.x > 0 and new_size.y > 0 and target_visual_size.x > 0:
			sprite.scale = target_visual_size / new_size

func _physics_process(delta):'''
content = content.replace('\nfunc _physics_process(delta):', set_texture_func)

# Fix Animation Logic
new_anim = '''	# แอนิเมชัน
	walk_anim_timer += delta
	if walk_anim_timer >= 0.15:
		walk_anim_timer = 0.0
		walk_anim_frame += 1
		if walk_anim_frame > 3:
			walk_anim_frame = 1
			
		if dist < 200:
			set_hena_texture("res://assets/hena_demon_attk" + str(walk_anim_frame) + ".png")
		elif velocity.length() > 0:
			set_hena_texture("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")'''

content = re.sub(r'	# แอนิเมชัน.*?(?=\nfunc take_damage)', new_anim + '\n', content, flags=re.DOTALL)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)