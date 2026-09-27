import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

new_script = '''extends CharacterBody2D

var speed = 150
var max_health = 150
var health = 150
var player_node = null
var is_dead = false
var damage = 2

var intro_started = false
var intro_done = false

@onready var sprite = 

func _ready():
	add_to_group("enemies")
	player_node = get_tree().current_scene.get_node_or_null("player")

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

func _physics_process(delta):
	if is_dead or not intro_done or not player_node: return
	
	var direction = (player_node.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	if direction.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	if global_position.distance_to(player_node.global_position) < 100:
		if player_node.has_method("take_damage") and not player_node.is_dead:
			if .time_left == 0:
				player_node.take_damage(damage)
				.start()

func take_damage(amount):
	if is_dead or not intro_done: return
	health -= amount
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func die():
	is_dead = true
	await show_text("Hena: ไม่นะสิ่งที่ฉันสร้างไว้ ไม่นะ ไม่ . . . . .", 4.0)
	
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog and dialog_label:
		dialog_label.text = "Victory! ภารกิจสำเร็จ คุณรอดชีวิตแล้ว!"
		dialog.visible = true
	
	queue_free()
'''

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(new_script)