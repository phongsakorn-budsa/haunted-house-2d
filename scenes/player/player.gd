extends CharacterBody2D

const SPEED = 400.0
var inventory: Array = []
var health: int = 3
var is_invulnerable: bool = false
var is_frozen: bool = false
var has_gun: bool = false
var has_flashlight: bool = false
var current_slot: int = 0 # 0=มือเปล่า, 1=ไฟฉาย, 2=ปืน
var ammo: int = 7
const MAX_AMMO: int = 7
var is_reloading: bool = false

func pickup_gun():
	has_gun = true
	
	var inventory_ui = get_tree().current_scene.get_node_or_null("UI/Inventory")
	if inventory_ui and not inventory_ui.has_node("Slot2"):
		var slot1 = inventory_ui.get_node_or_null("Slot1")
		if slot1:
			var slot2 = slot1.duplicate()
			slot2.name = "Slot2"
			inventory_ui.add_child(slot2)
			
	equip_slot(2)
	print("Picked up gun!")
	
	var ui_icon = get_tree().current_scene.get_node_or_null("UI/Inventory/Slot2/Icon")
	if ui_icon:
		ui_icon.texture = load("res://assets/gun1911.png")
		ui_icon.modulate = Color(1, 1, 1, 1)

func equip_slot(slot_index: int):
	current_slot = slot_index
	
	# อัปเดต UI กรอบช่องเก็บของ (ถ้ามี)
	var slot1 = get_tree().current_scene.get_node_or_null("UI/Inventory/Slot1")
	var slot2 = get_tree().current_scene.get_node_or_null("UI/Inventory/Slot2")
	if slot1: slot1.modulate = Color(1,1,1,1) if current_slot == 1 else Color(0.5,0.5,0.5,1)
	if slot2: slot2.modulate = Color(1,1,1,1) if current_slot == 2 else Color(0.5,0.5,0.5,1)
	
	if current_slot == 1:
		if has_node("WeaponPivot"): $WeaponPivot.visible = false
		if has_node("PointLight2D"):
			$PointLight2D.enabled = true
			$PointLight2D.scale = Vector2(20, 20)
	elif current_slot == 2:
		if has_node("WeaponPivot"): $WeaponPivot.visible = true
		if has_node("PointLight2D"):
			$PointLight2D.enabled = true
			$PointLight2D.scale = Vector2(5, 5) # แสงแคบลงตอนถือปืน
			
	update_ammo_ui()

func shoot():
	if current_slot != 2 or not has_node("WeaponPivot/GunSprite"): return
	if ammo <= 0 or is_reloading: return
	
	ammo -= 1
	update_ammo_ui()
	
	$WeaponPivot/GunSprite.play("shoot")
	
	var bullet_scene = load("res://scenes/items/bullet.tscn")
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = $WeaponPivot/GunSprite/Muzzle.global_position
		
		var dir = global_position.direction_to(get_global_mouse_position())
		bullet.direction = dir
		bullet.rotation = dir.angle()
		
		get_tree().current_scene.add_child(bullet)

func update_ammo_ui():
	var label = get_tree().current_scene.get_node_or_null("UI/AmmoLabel")
	if label:
		if current_slot == 2:
			label.visible = true
			if is_reloading:
				label.text = "Reloading..."
			else:
				label.text = "Ammo: " + str(ammo) + "/" + str(MAX_AMMO)
		else:
			label.visible = false

func reload():
	if current_slot != 2 or is_reloading or ammo == MAX_AMMO: return
	is_reloading = true
	update_ammo_ui()
	await get_tree().create_timer(1.5).timeout
	ammo = MAX_AMMO
	is_reloading = false
	update_ammo_ui()

func _physics_process(delta):
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	# เลือกช่องเก็บของ
	if Input.is_key_pressed(KEY_1) and has_flashlight and current_slot != 1:
		equip_slot(1)
	if Input.is_key_pressed(KEY_2) and has_gun and current_slot != 2:
		equip_slot(2)
		
	# รีโหลดกระสุน
	if Input.is_key_pressed(KEY_R):
		reload()
		
	if current_slot == 2 and has_node("WeaponPivot"):
		var mouse_pos = get_global_mouse_position()
		$WeaponPivot.look_at(mouse_pos)
		
		if mouse_pos.x < global_position.x:
			$WeaponPivot/GunSprite.flip_v = true
		else:
			$WeaponPivot/GunSprite.flip_v = false
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if $WeaponPivot/GunSprite.animation != "shoot" or not $WeaponPivot/GunSprite.is_playing():
				shoot()
	
	var direction = Vector2.ZERO
	
	# รองรับทั้งปุ่มลูกศรแบบเดิม
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# รองรับ WASD แบบเช็คคีย์ตรงๆ (แก้ปัญหา Input Map ไม่ได้ตั้งไว้)
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
		
	# Normalize เพื่อให้เดินเฉียงความเร็วไม่เพิ่มขึ้น
	if direction.length() > 0:
		direction = direction.normalized()
		
		# เล่นแอนิเมชันเดิน
		if has_node("AnimatedSprite2D"):
			if direction.y < 0 and direction.x == 0:
				$AnimatedSprite2D.play("walk_up")
			elif direction.x != 0:
				$AnimatedSprite2D.play("walk")
				# หันหน้าซ้าย-ขวา
				$AnimatedSprite2D.flip_h = direction.x < 0
			else:
				# ถ้าเดินลง อย่างเดียว ไม่เฉียง
				$AnimatedSprite2D.play("idle")
	else:
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.play("idle")
	
	velocity = direction * SPEED
	move_and_slide()

# ฟังก์ชันรับดาเมจ
func take_damage():
	if is_invulnerable:
		return
		
	health -= 1
	print("Player took damage! Health: ", health)
	
	# อัปเดต UI หัวใจ
	var health_ui = get_tree().current_scene.get_node_or_null("UI/HealthUI")
	if health_ui:
		var hearts = health_ui.get_children()
		for i in range(hearts.size()):
			hearts[i].visible = (i < health)
			
	if health <= 0:
		# ตายแล้ว โชว์ Game Over
		var game_over_screen = get_tree().current_scene.get_node_or_null("UI/GameOverScreen")
		if game_over_screen:
			game_over_screen.visible = true
			get_tree().paused = true
	else:
		# เป็นอมตะชั่วคราวและกระพริบแดง
		is_invulnerable = true
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.modulate = Color(1, 0, 0, 0.5) 
		
		await get_tree().create_timer(1.0).timeout
		is_invulnerable = false
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)

# ฟังก์ชันสำหรับเก็บไอเทม
func pickup_item(item_name: String):
	inventory.append(item_name)
	print("เก็บไอเทม: ", item_name, " | ช่องเก็บของ: ", inventory)
	
	if item_name == "Flashlight":
		has_flashlight = true
		equip_slot(1)
		
		# อัปเดต UI ช่องเก็บของ
		var ui_icon = get_tree().current_scene.get_node_or_null("UI/Inventory/Slot1/Icon")
		if ui_icon:
			# โหลดรูปไฟฉายมาโชว์ในช่องเก็บของ
			ui_icon.texture = load("res://assets/flashlight_sprite.png")
			ui_icon.modulate = Color(1, 1, 1, 1)

var keys_collected: int = 0
var quest_stage: int = 0 # 0=สำรวจ, 1=หากุญแจ, 2=กลับไปหา Hena, 3=เสร็จสิ้น

func _ready():
	# หน่วงเวลาอัปเดต UI เล็กน้อยรอให้ UI โหลดเสร็จ
	call_deferred("update_quest_ui")
	if has_node("WeaponPivot/GunSprite"):
		$WeaponPivot/GunSprite.animation_finished.connect(_on_gun_animation_finished)

func _on_gun_animation_finished():
	if $WeaponPivot/GunSprite.animation == "shoot":
		$WeaponPivot/GunSprite.play("idle")

func update_quest_ui():
	var quest_label = get_tree().current_scene.get_node_or_null("UI/QuestLabel")
	if quest_label:
		if quest_stage == 0:
			quest_label.text = "ภารกิจ: สำรวจปราสาท"
		elif quest_stage == 1:
			quest_label.text = "ภารกิจ: หากุญแจ (" + str(keys_collected) + "/3)"
		elif quest_stage == 2:
			quest_label.text = "ภารกิจ: กลับไปหา Hena"
		elif quest_stage == 3:
			quest_label.text = "ภารกิจ: สำเร็จ!"

func pickup_key():
	if quest_stage == 1:
		keys_collected += 1
		print("เก็บกุญแจแล้ว! ", keys_collected, "/3")
		if keys_collected >= 3:
			quest_stage = 2
		update_quest_ui()
