extends StaticBody2D

var player_node: Node2D = null
var is_mouse_hovering: bool = false
var is_talking: bool = false

# ตัวแปรแอนิเมชันตอนกลายร่าง
var is_transforming: bool = false
var anim_timer: float = 0.0
var anim_frame: int = 1
var target_visual_size = Vector2.ZERO

@onready var label = $Label

func _ready():
	if has_node("Sprite2D") and $Sprite2D.texture:
		target_visual_size = $Sprite2D.texture.get_size() * $Sprite2D.scale
	call_deferred("_start_intro")

func set_hena_texture(path: String):
	if has_node("Sprite2D"):
		var new_tex = load(path)
		if new_tex:
			$Sprite2D.texture = new_tex
			if target_visual_size != Vector2.ZERO:
				var tex_size = new_tex.get_size()
				if tex_size.x > 0 and tex_size.y > 0:
					$Sprite2D.scale = Vector2(target_visual_size.x / tex_size.x, target_visual_size.y / tex_size.y)

func _start_intro():
	var p = get_tree().current_scene.get_node_or_null("player")
	if p and p.quest_stage == 0:
		is_talking = true
		await show_text("Player: โอ้ย เจ็บจัง ฉันอยู่ที่ไหนเนี่ยยย", 3.0)
		await show_text("Hena: ไง นายโอเคไหม นายกำลังอยู่ในปราสาทที่ไหนสักที่หนึ่ง\nนายโดนจับตัวมาหนะ ฉันก็ด้วยย", 4.0)
		await show_text("Player: ฉันจะออกจากที่นี่ได้ยังไง", 3.0)
		await show_text("Hena: ฉันรู้นะแต่ฉันเจ็บขามาก ในปราสาทนี้พวกมันมีอยู่เต็มไปหมด\nนายพักก่อน ถ้านายอยากออกเมื่อไหร่ ค่อยมาคุยกับฉัน", 5.0)
		if is_instance_valid(p):
			p.quest_stage = 1
			p.update_quest_ui()
		var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
		if dialog_box:
			dialog_box.visible = false
		is_talking = false

func _process(delta):
	var can_interact = (player_node != null and is_mouse_hovering)
	label.visible = can_interact and not is_talking
	
	if is_transforming and has_node("Sprite2D"):
		anim_timer += delta
		if anim_timer >= 0.15: # สลับรูปอย่างรวดเร็วทุก 0.15 วิ
			anim_timer = 0.0
			anim_frame += 1
			if anim_frame > 3:
				anim_frame = 1
			set_hena_texture("res://assets/hena_tranferdemon" + str(anim_frame) + ".png")

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		talk_to_player()

func show_text(text: String, duration: float = 3.5):
	var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog_box and dialog_label:
		dialog_box.visible = true
		dialog_label.text = text
		await get_tree().create_timer(duration).timeout

func talk_to_player():
	if is_talking or player_node == null: return
	is_talking = true
	var p = player_node
	
	if p.quest_stage == 1:
		await show_text("Hena: ถ้านายอยากออกจากที่นี่ จงตามหากุญแจ 3 ดอก\nมันจะอยู่ในปราสาทนี้...", 4.0)
		if is_instance_valid(p):
			p.quest_stage = 2
			p.update_quest_ui()
	elif p.quest_stage == 2:
		await show_text("Hena: รีบไปหากุญแจสิ! ต้องใช้ตั้ง 3 ดอกนะ (" + str(p.keys_collected) + "/3)", 3.0)
	elif p.quest_stage == 3:
		await show_text("Hena: กุญแจนี้จะนำเอาไปไขประตูที่อยู่ในปราสาท\nข้างในจะเป็นห้องทำน้ำยาให้ฉันกลับมาแข็งแรง\nจากนั้นนายจะออกไปก็ได้เลย ฉันจะพานายไป", 5.0)
		await show_text("Hena: ส่วนผสมที่ต้องใช้ อาจจะอยู่ในพวกมัน\nนายต้องจัดการและเอาส่วนผสมไปใส่ในเครื่อง", 4.0)
		await show_text("Hena: ต้องใช้ ไลฟ์สมุนไพรสีเขียว เห็ดสีแดง และคริสตัลสีฟ้า\nช่วยฉันออกไปด้วยนะ", 4.5)
		if is_instance_valid(p):
			p.pickup_gun()
			p.quest_stage = 4
			p.update_quest_ui()
	elif p.quest_stage == 4:
		await show_text("Hena: เอาปืนไปยิงพวกมอนสเตอร์ แล้วหาส่วนผสมมาให้ฉันนะ!", 3.0)
	elif p.quest_stage == 5:
		await show_text("Hena: ขอบใจมากนะนายเป็นคนดี ฮึฮึ... *ดื่มน้ำยา*", 4.0)
		
		# เริ่มกลายร่าง
		is_transforming = true
		await show_text("Hena: ยานี่จะทำให้ฉันได้รับพลังที่แท้จริง\nและโลกนี้จะต้องถูกทำลาย!!", 4.0)
		
		# กลายร่างสมบูรณ์เป็นรูปสุดท้าย
		is_transforming = false
		set_hena_texture("res://assets/hena_demon.png")
		await show_text("Hena: ฮ่าๆๆๆ ตายซะ!!", 3.0)
		
		var dialog_box = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
		if dialog_box:
			dialog_box.visible = false
			
		# ทำจอมืด (Fade to black)
		var canvas = CanvasLayer.new()
		canvas.layer = 100
		get_tree().current_scene.add_child(canvas)
		
		var fade = ColorRect.new()
		fade.color = Color(0, 0, 0, 0)
		fade.set_anchors_preset(Control.PRESET_FULL_RECT)
		canvas.add_child(fade)
		
		var tween = get_tree().create_tween()
		tween.tween_property(fade, "color:a", 1.0, 2.0) # เฟดเป็นสีดำใน 2 วินาที
		await tween.finished
		
		# แทนที่จะเปลี่ยนฉาก ให้ใช้วิธีเทเลพอร์ตผู้เล่นไปที่ห้องบอสแทน (เพื่อรักษา UI และตัวละครไว้)
		var boss_room = get_tree().current_scene.get_node_or_null("boss_room")
		if boss_room:
			p.global_position = boss_room.global_position + Vector2(400, 480) # วาร์ปไปตรงกลางห้อง
		else:
			p.global_position = Vector2(5000, 0) # พิกัดสำรองถ้าหาโหนดไม่เจอ
			
		# เฟดหน้าจอกลับมาสว่าง
		var tween2 = get_tree().create_tween()
		tween2.tween_property(fade, "color:a", 0.0, 2.0)
		await tween2.finished
		fade.queue_free()
		
		if is_instance_valid(p):
			p.quest_stage = 6
			p.update_quest_ui()
			
	elif p.quest_stage == 6:
		pass
		
	var dbox = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	if dbox and p.quest_stage != 5:
		dbox.visible = false
	is_talking = false

func _on_interact_area_body_entered(body):
	if body.name == "player":
		player_node = body

func _on_interact_area_body_exited(body):
	if body.name == "player":
		player_node = null

func _on_interact_area_mouse_entered():
	is_mouse_hovering = true

func _on_interact_area_mouse_exited():
	is_mouse_hovering = false
