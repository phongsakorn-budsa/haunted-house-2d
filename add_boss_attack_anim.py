import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_anim = '''	# เดินสลับรูปภาพ (Walk Animation)
	if velocity.length() > 0:
		walk_anim_timer += delta
		if walk_anim_timer >= 0.15:
			walk_anim_timer = 0.0
			walk_anim_frame += 1
			if walk_anim_frame > 3:
				walk_anim_frame = 1
			sprite.texture = load("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")'''

new_anim = '''	# แอนิเมชันโจมตีและเดิน
	if global_position.distance_to(player_node.global_position) < 200:
		walk_anim_timer += delta
		if walk_anim_timer >= 0.15:
			walk_anim_timer = 0.0
			walk_anim_frame += 1
			if walk_anim_frame > 3:
				walk_anim_frame = 1
			sprite.texture = load("res://assets/hena_demon_attk" + str(walk_anim_frame) + ".png")
	elif velocity.length() > 0:
		walk_anim_timer += delta
		if walk_anim_timer >= 0.15:
			walk_anim_timer = 0.0
			walk_anim_frame += 1
			if walk_anim_frame > 3:
				walk_anim_frame = 1
			sprite.texture = load("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")'''

content = content.replace(old_anim, new_anim)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)