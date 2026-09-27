extends CharacterBody2D

var speed = 150
var max_health = 150
var health = 150
var player_node = null
var is_dead = false
var damage = 2

var intro_started = false
var walk_anim_timer = 0.0
var walk_anim_frame = 1
var is_attacking = false
var target_visual_size = Vector2.ZERO
var intro_done = false
var health_bar = ProgressBar.new()

@onready var sprite = $Sprite2D

func _ready():
	add_to_group("enemies")
	player_node = get_tree().current_scene.get_node_or_null("player")
	
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.size = Vector2(120, 15)
	health_bar.position = Vector2(-60, -180)
	health_bar.show_percentage = false
	health_bar.modulate = Color(1, 0, 0)
	health_bar.visible = false
	add_child(health_bar)
	$AttackTimer.wait_time = 1.0
	
	if sprite.texture:
		target_visual_size = sprite.texture.get_size() * sprite.scale
	else:
		var t = load("res://assets/hena_demon.png")
		target_visual_size = t.get_size() * sprite.scale
	
	# สร้างกำแพงล่องหนกั้นขอบสนาม
	var walls = StaticBody2D.new()
	get_parent().call_deferred("add_child", walls)
	
	var shapes = [
		{"pos": Vector2(430, 200), "size": Vector2(1800, 50)}, # บน (ขยับขึ้นไปเยอะขึ้น)
		{"pos": Vector2(430, 750), "size": Vector2(1800, 50)}, # ล่าง (ขยับลงมาเยอะขึ้น)
		{"pos": Vector2(-300, 450), "size": Vector2(50, 1000)}, # ซ้าย (ขยับออกไปกว้างขึ้น)
		{"pos": Vector2(1200, 450), "size": Vector2(50, 1000)}  # ขวา (ขยับออกไปกว้างขึ้น)
	]
	
	for s in shapes:
		var col = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = s["size"]
		col.shape = rect
		col.position = s["pos"]
		walls.call_deferred("add_child", col)

func _process(delta):
	if not intro_started and player_node and player_node.quest_stage >= 6:
		intro_started = true
		_play_intro()

func show_text(text: String, duration: float = 3.0):
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog and dialog_label:
		dialog.visible = true
		dialog_label.text = text
		await get_tree().create_timer(duration).timeout

func _play_intro():
	await show_text("Player: ฉันอยู่ที่ไหนอีกแล้วเนี่ย", 3.0)
	await show_text("Hena: นายเป็นคนดีหรือโง่กันแน่นะ 5555555555 งั้นก็ตายซะ!", 4.0)
	await show_text("Player: Hena เดี๋ยวก่อนนน!", 2.5)
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog:
		dialog.visible = false
		
	intro_done = true
	health_bar.visible = true

func set_hena_texture(path: String):
	var tex = load(path)
	if tex:
		sprite.texture = tex
		var new_size = tex.get_size()
		if new_size.x > 0 and new_size.y > 0 and target_visual_size.x > 0:
			sprite.scale = target_visual_size / new_size

func _physics_process(delta):
	if is_dead or not intro_done or not player_node: return
	
	var dist = global_position.distance_to(player_node.global_position)
	
	if dist < 200:
		if player_node.has_method("take_damage"):
			if $AttackTimer.time_left == 0:
				player_node.take_damage(1) # ลดเลือดแค่ 1 ทีละครั้ง
				$AttackTimer.start()
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
			
		if dist < 200:
			set_hena_texture("res://assets/hena_demon_attk" + str(walk_anim_frame) + ".png")
		elif velocity.length() > 0:
			set_hena_texture("res://assets/hena_demon_walk" + str(walk_anim_frame) + ".png")

func take_damage(amount):
	if is_dead or not intro_done: return
	health -= amount
	health_bar.value = health
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	sprite.texture = load("res://assets/hena_demon.png") # กลับเป็นท่ายืนนิ่ง
	health_bar.visible = false
	
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)
	await show_text("Player: ฉันไปแล้ว ฉันกลัวแล้ว ไม่เอาแล้วว ไปอยู่บ้านเฉยๆ ก็ดีแล้ว", 4.0)
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog:
		dialog.visible = false
		
	# วาร์ปไปหน้าจบเกม
	get_tree().change_scene_to_file("res://scenes/ui/chapter_end.tscn")
	queue_free()
