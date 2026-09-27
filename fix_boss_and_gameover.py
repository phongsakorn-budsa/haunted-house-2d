import io
import re

# 1. Fix GameOver text in world.tscn
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    world_content = f.read()

world_content = re.sub(r'text = "เน€เธฃเธดเนˆเธกเน€เธ เธกเนƒเธซเธกเนˆ"', 'text = "เริ่มเกมใหม่"', world_content)
world_content = re.sub(r'text = "[^"]*เน€[^"]*"', 'text = "เริ่มเกมใหม่"', world_content) # aggressive catch for any mojibake starting with เน

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(world_content)

# 2. Fix boss_hena.gd (Damage and Blinking)
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    boss_content = f.read()

# Add is_attacking variable
boss_content = boss_content.replace('var walk_anim_frame = 1\n', 'var walk_anim_frame = 1\nvar is_attacking = false\n')

# Add wait_time to timer in _ready
boss_content = boss_content.replace('add_child(health_bar)\n', 'add_child(health_bar)\n\t.wait_time = 1.0\n')

# Completely replace _physics_process
new_physics = '''func _physics_process(delta):
	if is_dead or not intro_done or not player_node: return
	
	var dist = global_position.distance_to(player_node.global_position)
	
	if dist < 200:
		if player_node.has_method("take_damage"):
			if .time_left == 0:
				player_node.take_damage(1) # ลดเลือดแค่ 1 ทีละครั้ง
				.start()
				is_attacking = true
				var t = get_tree().create_timer(0.45)
				t.timeout.connect(func(): is_attacking = false)
	
	if not is_attacking:
		var direction = (player_node.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		if direction.x < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity = Vector2.ZERO
		
	# แอนิเมชัน
	walk_anim_timer += delta
	if walk_anim_timer >= 0.15:
		walk_anim_timer = 0.0
		walk_anim_frame += 1
		if walk_anim_frame > 3:
			walk_anim_frame = 1
			
		if is_attacking:
			sprite.texture = load("res://assets/hena_demon_attk" + str(walk_anim_frame) + ".png")
		elif velocity.length() > 0:
			sprite.texture = load("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")
			
func take_damage(amount):'''

boss_content = re.sub(r'func _physics_process\(delta\):.*?func take_damage\(amount\):', new_physics, boss_content, flags=re.DOTALL)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(boss_content)