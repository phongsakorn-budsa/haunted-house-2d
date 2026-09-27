import io
with io.open('scenes/interactables/hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_warp = '''		var tween = get_tree().create_tween()
		tween.tween_property(fade, "color:a", 1.0, 2.0) # เฟดเป็นสีดำใน 2 วินาที
		await tween.finished
		
		# เปลี่ยนฉากไปที่ห้องบอส
		get_tree().change_scene_to_file("res://boss_room.tscn")
		
	elif p.quest_stage == 6:'''

new_warp = '''		var tween = get_tree().create_tween()
		tween.tween_property(fade, "color:a", 1.0, 2.0) # เฟดเป็นสีดำใน 2 วินาที
		await tween.finished
		
		# แทนที่จะเปลี่ยนฉาก ให้ใช้วิธีเทเลพอร์ตผู้เล่นไปที่ห้องบอสแทน (เพื่อรักษา UI และตัวละครไว้)
		var boss_room = get_tree().current_scene.get_node_or_null("boss_room")
		if boss_room:
			p.global_position = boss_room.global_position + Vector2(0, 150) # วาร์ปไปตรงกลางห้อง
		else:
			p.global_position = Vector2(5000, 0) # พิกัดสำรองถ้าหาโหนดไม่เจอ
			
		# เฟดหน้าจอกลับมาสว่าง
		var tween2 = get_tree().create_tween()
		tween2.tween_property(fade, "color:a", 0.0, 2.0)
		await tween2.finished
		fade.queue_free()
		
	elif p.quest_stage == 6:'''

content = content.replace(old_warp, new_warp)

with io.open('scenes/interactables/hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)