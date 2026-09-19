extends Area2D

# สามารถปรับแต่งค่าใน Inspector ได้เลย
@export var speed: float = 600.0
@export var direction: Vector2 = Vector2(-1, 0) # ทิศทางที่ผีจะวิ่ง (-1, 0 คือวิ่งไปทางซ้าย)
@export var move_distance: float = 1200.0

@onready var sprite = $FakeGhost

var has_triggered = false

func _ready():
	# ซ่อนผีไว้ก่อนจนกว่าจะเดินมาเหยียบ
	sprite.visible = false

func _on_body_entered(body):
	# ถ้าคนที่มาเหยียบคือผู้เล่น และยังไม่เคยทำงานมาก่อน
	if body.name == "player" and not has_triggered:
		has_triggered = true
		trigger_jumpscare(body)

func trigger_jumpscare(player_node):
	sprite.visible = true
	var start_pos = sprite.position
	var target_pos = start_pos + (direction.normalized() * move_distance)
	
	# แช่แข็งผู้เล่น
	if player_node:
		player_node.is_frozen = true
	
	# แสดงข้อความแบบเดียวกันกับ Hena
	var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog_box and dialog_label:
		dialog_box.visible = true
		dialog_label.text = "Player: เห้ย!! นั่นใครหน่ะ!?"
	
	# สร้าง Tween เพื่อทำให้ผีวิ่งจากจุด A ไปจุด B อย่างสมูท
	var tween = create_tween()
	var duration = move_distance / speed
	tween.tween_property(sprite, "position", target_pos, duration)
	
	# รอเวลาสัก 2.5 วินาที
	await get_tree().create_timer(2.5).timeout
	
	# ปิดข้อความ และปลดล็อคผู้เล่น
	if dialog_box:
		dialog_box.visible = false
	if player_node:
		player_node.is_frozen = false
		
	queue_free()
