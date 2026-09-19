extends CharacterBody2D

const SPEED = 150.0
var player: Node2D = null
var health: int = 3
var is_chasing = false

func take_damage(amount=1):
	health -= amount
	if health <= 0:
		queue_free()

func _ready():
	call_deferred("_find_player")

func _find_player():
	var root = get_tree().current_scene
	if root:
		player = root.get_node_or_null("player")

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	var is_hitting = false
	
	if is_chasing and player:
		# โหมดไล่ล่า
		direction = global_position.direction_to(player.global_position)
		
		# เช็คการชนตลอดเวลา เพื่อทำดาเมจถ้ายังซ้อนทับกันอยู่
		if has_node("Hitbox"):
			for body in $Hitbox.get_overlapping_bodies():
				if body.name == "player":
					is_hitting = true
					if body.has_method("take_damage"):
						body.take_damage()
	else:
		# โหมดเดินสุ่ม (ลอยไปมา)
		wander_timer -= delta
		if wander_timer <= 0:
			# สุ่มทิศทางใหม่ทุกๆ 2-4 วินาที
			wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			wander_timer = randf_range(2.0, 4.0)
			
			# โอกาส 30% ที่จะหยุดลอยนิ่งๆ
			if randf() < 0.3:
				wander_direction = Vector2.ZERO
				
		direction = wander_direction

	# ส่วนควบคุม Animation และการเคลื่อนที่
	if has_node("AnimatedSprite2D"):
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false # หันขวา
		elif direction.x < 0:
			$AnimatedSprite2D.flip_h = true  # หันซ้าย
			
		if is_hitting:
			$AnimatedSprite2D.play("attack")
			velocity = Vector2.ZERO # หยุดเดินตอนตี
		elif direction == Vector2.ZERO:
			$AnimatedSprite2D.pause() # ให้อยู่นิ่งๆ
			velocity = Vector2.ZERO
		else:
			$AnimatedSprite2D.play("walk")
			if is_chasing:
				velocity = direction * SPEED
			else:
				velocity = direction * (SPEED * 0.5) # เดินสุ่มให้ช้าลงครึ่งนึง

	move_and_slide()

func _on_hitbox_body_entered(body):
	if body.name == "player" and body.has_method("take_damage"):
		body.take_damage()

func _on_aggro_area_body_entered(body):
	if body.name == "player":
		is_chasing = true

func _on_aggro_area_body_exited(body):
	if body.name == "player":
		is_chasing = false
