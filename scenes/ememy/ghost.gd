extends CharacterBody2D

const SPEED = 50.0
var health = 3
var player: Node2D = null

@onready var sprite = $AnimatedSprite2D

var state = "wander"
var wander_direction = Vector2.ZERO
var wander_timer = 0.0
var attack_timer = 0.0

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance < 300:
			state = "chase"
		else:
			state = "wander"
	
	if state == "chase" and player:
		var direction = global_position.direction_to(player.global_position)
		
		if distance_to_player() < 40:
			sprite.play("attack")
			velocity = Vector2.ZERO
			
			# โจมตีด้วย Timer ชัวร์ 100%
			attack_timer -= delta
			if attack_timer <= 0:
				if not player.is_invulnerable:
					player.take_damage()
				attack_timer = 1.5 # ตีทุกๆ 1.5 วินาที
				
		else:
			sprite.play("walk")
			velocity = direction * SPEED
			attack_timer = 0.5 # ถ้าเดินอยู่ รีเซ็ตให้รอแปปนึงก่อนตี
		
		if direction.x != 0:
			sprite.flip_h = direction.x < 0
			
	elif state == "wander":
		wander_timer -= delta
		if wander_timer <= 0:
			wander_timer = randf_range(2.0, 4.0)
			var random_angle = randf() * PI * 2
			wander_direction = Vector2(cos(random_angle), sin(random_angle))
			
			if randf() < 0.3:
				wander_direction = Vector2.ZERO
				
		velocity = wander_direction * (SPEED * 0.5)
		
		if velocity.length() > 0:
			sprite.play("walk")
			sprite.flip_h = velocity.x < 0
		else:
			sprite.play("walk")
			
	move_and_slide()

func distance_to_player() -> float:
	if player:
		return global_position.distance_to(player.global_position)
	return 9999.0

func _on_aggro_area_body_entered(body):
	if body.name == "player":
		player = body

func _on_aggro_area_body_exited(body):
	if body.name == "player":
		player = null

func take_damage(amount=1):
	health -= amount
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		drop_item()
		queue_free()

func drop_item():
	if randf() < 0.6: # 60% drop rate
		var p = get_tree().current_scene.get_node_or_null("player")
		if p and p.quest_stage == 4:
			var available_drops = []
			if not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("Life_Herb")):
				available_drops.append("res://scenes/items/life_herb.tscn")
			if not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("SoulCrystal")):
				available_drops.append("res://scenes/items/soul_crystal.tscn")
			if not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("BloodmoonMushroom")):
				available_drops.append("res://scenes/items/bloodmoon_mushroom.tscn")
			
			if available_drops.size() > 0:
				var drop_scene_path = available_drops[randi() % available_drops.size()]
				var drop_scene = load(drop_scene_path)
				if drop_scene:
					var item = drop_scene.instantiate()
					item.global_position = global_position
					get_tree().current_scene.call_deferred("add_child", item)

func _on_hitbox_body_entered(body):
	if body.name == "player":
		if not body.is_invulnerable:
			body.take_damage()
