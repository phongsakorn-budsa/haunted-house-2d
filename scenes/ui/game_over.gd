extends ColorRect

func _ready():
	# เชื่อมต่อปุ่มเมื่อกดให้ไปทำงานที่ฟังก์ชัน _on_restart_pressed
	$RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	# ปลดล็อคเวลา (Unpause)
	get_tree().paused = false
	visible = false # ซ่อนหน้า Game Over
	
	var p = get_tree().current_scene.get_node_or_null("player")
	if p:
		if p.has_method("heal_to_full"):
			p.heal_to_full()
			
		# เช็ค Checkpoint
		if p.quest_stage >= 6:
			# สู้บอส
			var boss_room = get_tree().current_scene.get_node_or_null("boss_room")
			if boss_room:
				p.global_position = boss_room.global_position + Vector2(400, 480)
				var boss = boss_room.get_node_or_null("HenaDemon")
				if boss:
					boss.health = boss.max_health
					if boss.get("health_bar"):
						boss.health_bar.value = boss.health
					boss.global_position = boss_room.global_position + Vector2(983.25, 480.625)
					boss.is_attacking = false
					boss.intro_started = false
					boss.intro_done = false
					if boss.get("sprite"):
						boss.sprite.texture = load("res://assets/hena_demon.png")
		else:
			# เควสปกติ วาร์ปไปจุดเกิดข้าง Hena
			var hena = get_tree().current_scene.get_node_or_null("Hena")
			if hena:
				p.global_position = hena.global_position + Vector2(0, 100)
			else:
				p.global_position = Vector2(0, 0)
