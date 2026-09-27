import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add walk animation variables
content = content.replace('var intro_started = false\n', 'var intro_started = false\nvar walk_anim_timer = 0.0\nvar walk_anim_frame = 1\n')

# 2. Add animation logic to _physics_process
old_phys = '''	var direction = (player_node.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:'''

new_phys = '''	var direction = (player_node.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# เดินสลับรูปภาพ (Walk Animation)
	if velocity.length() > 0:
		walk_anim_timer += delta
		if walk_anim_timer >= 0.15:
			walk_anim_timer = 0.0
			walk_anim_frame += 1
			if walk_anim_frame > 3:
				walk_anim_frame = 1
			sprite.texture = load("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")
	
	if direction.x < 0:'''

content = content.replace(old_phys, new_phys)

# 3. Revert to idle on death just in case
old_die = '''func die():
	is_dead = true
	health_bar.visible = false'''

new_die = '''func die():
	is_dead = true
	sprite.texture = load("res://assets/hena_demon.png") # กลับเป็นท่ายืนนิ่ง
	health_bar.visible = false'''

content = content.replace(old_die, new_die)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)