import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_ready = '''	health_bar.show_percentage = false
	health_bar.modulate = Color(1, 0, 0)
	health_bar.visible = false
	add_child(health_bar)'''

new_ready = '''	health_bar.show_percentage = false
	health_bar.modulate = Color(1, 0, 0)
	health_bar.visible = false
	add_child(health_bar)
	
	# สร้างกำแพงล่องหนกั้นขอบสนาม
	var walls = StaticBody2D.new()
	get_parent().call_deferred("add_child", walls)
	
	var shapes = [
		{"pos": Vector2(430, 320), "size": Vector2(1400, 50)}, # บน
		{"pos": Vector2(430, 650), "size": Vector2(1400, 50)}, # ล่าง
		{"pos": Vector2(-150, 450), "size": Vector2(50, 800)}, # ซ้าย
		{"pos": Vector2(1050, 450), "size": Vector2(50, 800)}  # ขวา
	]
	
	for s in shapes:
		var col = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = s["size"]
		col.shape = rect
		col.position = s["pos"]
		walls.call_deferred("add_child", col)'''

content = content.replace(old_ready, new_ready)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)