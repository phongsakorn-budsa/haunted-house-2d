extends CharacterBody2D

const SPEED = 400.0
var health: int = 3
var is_invulnerable: bool = false
var is_frozen: bool = false

var has_gun: bool = false
var has_flashlight: bool = false
var is_reloading: bool = false
var ammo: int = 7
const MAX_AMMO: int = 7

var keys_collected: int = 0
var ingredients_collected: int = 0
var quest_stage: int = 0
var selected_hotbar_index: int = 0

func _ready():
	call_deferred("update_quest_ui")
	if has_node("WeaponPivot/GunSprite"):
		$WeaponPivot/GunSprite.animation_finished.connect(_on_gun_animation_finished)

func _on_gun_animation_finished():
	if $WeaponPivot/GunSprite.animation == "shoot":
		$WeaponPivot/GunSprite.play("idle")

func update_equipment():
	var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
	if inv_ui:
		var equip_slot = inv_ui.get_node("Bg/EquipSlot")
		
		if equip_slot.item_name == "Flashlight":
			if has_node("PointLight2D"):
				$PointLight2D.enabled = true
				$PointLight2D.scale = Vector2(20, 20)
		else:
			if has_node("PointLight2D"):
				$PointLight2D.enabled = false
		
		var hotbar = inv_ui.get_node("HotbarContainer")
		var active_slot = hotbar.get_child(selected_hotbar_index)
		
		has_gun = (active_slot.item_name == "Gun")
		
		if has_gun:
			if has_node("WeaponPivot"):
				$WeaponPivot.visible = true
		else:
			if has_node("WeaponPivot"):
				$WeaponPivot.visible = false
				
		inv_ui.set_active_hotbar(selected_hotbar_index)
				
	update_ammo_ui()

func pickup_item(item_name: String):
	var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
	if inv_ui:
		inv_ui.add_item(item_name)
	update_equipment()

func pickup_gun():
	pickup_item("Gun")

func pickup_key():
	if quest_stage == 2:
		keys_collected += 1
		if keys_collected >= 3:
			quest_stage = 3
		update_quest_ui()

func shoot():
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog and dialog.visible: return
	if not has_gun or not has_node("WeaponPivot/GunSprite"): return
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

func reload():
	if not has_gun or is_reloading or ammo == MAX_AMMO: return
	is_reloading = true
	update_ammo_ui()
	await get_tree().create_timer(1.5).timeout
	ammo = MAX_AMMO
	is_reloading = false
	update_ammo_ui()

func update_ammo_ui():
	var label = get_node_or_null("AmmoLabel")
	if label:
		if has_gun:
			label.visible = true
			if is_reloading:
				label.text = "Reload..."
			else:
				label.text = str(ammo) + "/" + str(MAX_AMMO)
		else:
			label.visible = false

func take_damage(amount=1):
	if is_invulnerable: return
	health -= amount
	
	var health_ui = get_tree().current_scene.get_node_or_null("UI/HealthUI")
	if health_ui:
		var hearts = health_ui.get_children()
		for i in range(hearts.size()):
			hearts[i].visible = (i < health)
			
	if health <= 0:
		var game_over_screen = get_tree().current_scene.get_node_or_null("UI/GameOverScreen")
		if game_over_screen:
			game_over_screen.visible = true
			get_tree().paused = true
	else:
		is_invulnerable = true
		if has_node("AnimatedSprite2D"): $AnimatedSprite2D.modulate = Color(1, 0, 0, 0.5) 
		await get_tree().create_timer(1.0).timeout
		is_invulnerable = false
		if has_node("AnimatedSprite2D"): $AnimatedSprite2D.modulate = Color(1, 1, 1, 1)

func heal_to_full():
	health = 3
	ammo = MAX_AMMO
	is_reloading = false
	update_ammo_ui()
	
	var health_ui = get_tree().current_scene.get_node_or_null("UI/HealthUI")
	if health_ui:
		var hearts = health_ui.get_children()
		for i in range(hearts.size()):
			hearts[i].visible = (i < health)

func update_quest_ui():
	heal_to_full() # ฮีลเลือดและเติมกระสุนเต็มเมื่อเควสเปลี่ยน
	var quest_label = get_tree().current_scene.get_node_or_null("UI/QuestLabel")
	if quest_label:
		if quest_stage == 0:
			quest_label.text = "ภารกิจ: คุยกับ Hena"
		elif quest_stage == 1:
			quest_label.text = "ภารกิจ: คุยกับ Hena อีกครั้งเพื่อหาทางออก"
		elif quest_stage == 2:
			quest_label.text = "ภารกิจ: หากุญแจ (" + str(keys_collected) + "/3)"
		elif quest_stage == 3:
			quest_label.text = "ภารกิจ: นำกุญแจ 3 ดอกกลับไปให้ Hena"
		elif quest_stage == 4:
			if ingredients_collected < 3: # Actually this is obsolete, we use has_item now, but keep for label logic
				quest_label.text = "ภารกิจ: เปิดห้องวิจัย (Lab Door) และล่าหาส่วนผสม (3 อย่าง)"
			else:
				quest_label.text = "ภารกิจ: นำส่วนผสมไปที่เครื่องผสมยา"
		elif quest_stage == 5:
			quest_label.text = "ภารกิจ: นำ Revival Potion กลับไปให้ Hena!"
		elif quest_stage == 6:
			quest_label.text = "ภารกิจ: กำจัดปีศาจ Hena!!"

func _physics_process(delta):
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dialog and dialog.visible:
		$AnimatedSprite2D.play("idle")
		if has_node("WeaponPivot/GunSprite"):
			$WeaponPivot/GunSprite.play("idle")
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if is_frozen:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if Input.is_key_pressed(KEY_R):
		reload()
		
	if has_gun and has_node("WeaponPivot"):
		var mouse_pos = get_global_mouse_position()
		$WeaponPivot.look_at(mouse_pos)
		
		if mouse_pos.x < global_position.x:
			$WeaponPivot/GunSprite.flip_v = true
		else:
			$WeaponPivot/GunSprite.flip_v = false
			
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if $WeaponPivot/GunSprite.animation != "shoot" or not $WeaponPivot/GunSprite.is_playing():
				shoot()
	
	if Input.is_key_pressed(KEY_1):
		selected_hotbar_index = 0
		update_equipment()
	if Input.is_key_pressed(KEY_2):
		selected_hotbar_index = 1
		update_equipment()
	if Input.is_key_pressed(KEY_3):
		selected_hotbar_index = 2
		update_equipment()
	if Input.is_key_pressed(KEY_4):
		selected_hotbar_index = 3
		update_equipment()
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_key_pressed(KEY_W): direction.y -= 1
	if Input.is_key_pressed(KEY_S): direction.y += 1
	if Input.is_key_pressed(KEY_A): direction.x -= 1
	if Input.is_key_pressed(KEY_D): direction.x += 1
		
	if direction.length() > 0:
		direction = direction.normalized()
		if has_node("AnimatedSprite2D"):
			if direction.y < 0 and direction.x == 0:
				$AnimatedSprite2D.play("walk_up")
			elif direction.x != 0:
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D.flip_h = direction.x < 0
			else:
				$AnimatedSprite2D.play("idle")
	else:
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.play("idle")
	
	velocity = direction * SPEED
	move_and_slide()
