extends StaticBody2D

var player_node = null
var is_mouse_hovering = false
var mixer_stage = 0

var is_mixing: bool = false
var anim_timer: float = 0.0
var anim_frame: int = 1
var target_visual_size = Vector2.ZERO

func _ready():
	if has_node("Sprite2D") and $Sprite2D.texture:
		target_visual_size = $Sprite2D.texture.get_size() * $Sprite2D.scale
	if has_node("InteractArea"):
		$InteractArea.mouse_entered.connect(_on_mouse_entered)
		$InteractArea.mouse_exited.connect(_on_mouse_exited)
		$InteractArea.body_entered.connect(_on_body_entered)
		$InteractArea.body_exited.connect(_on_body_exited)

func set_mixer_texture(path: String):
	if has_node("Sprite2D"):
		var new_tex = load(path)
		if new_tex:
			$Sprite2D.texture = new_tex
			if target_visual_size != Vector2.ZERO:
				var tex_size = new_tex.get_size()
				if tex_size.x > 0 and tex_size.y > 0:
					$Sprite2D.scale = Vector2(target_visual_size.x / tex_size.x, target_visual_size.y / tex_size.y)

func _process(delta):
	if is_mixing and has_node("Sprite2D"):
		anim_timer += delta
		if anim_timer >= 0.15: # เปลี่ยนรูปทุก 0.15 วินาที
			anim_timer = 0.0
			anim_frame += 1
			if anim_frame > 3:
				anim_frame = 1
			set_mixer_texture("res://assets/Ingredientmixer_running" + str(anim_frame) + ".png")

func _on_mouse_entered():
	is_mouse_hovering = true

func _on_mouse_exited():
	is_mouse_hovering = false

func show_dialog(text: String):
	var dialog = get_tree().current_scene.get_node_or_null("UI/DialogueBox")
	var dialog_label = get_tree().current_scene.get_node_or_null("UI/DialogueBox/Label")
	if dialog and dialog_label:
		dialog_label.text = text
		dialog.visible = true
		await get_tree().create_timer(3.0).timeout
		dialog.visible = false

func _input(event):
	var can_interact = (player_node != null and is_mouse_hovering)
	if can_interact and event is InputEventKey and event.pressed and event.keycode == KEY_E and not event.echo:
		if is_mixing: return # ไม่ให้กดระหว่างผสม
		
		var p = player_node
		
		if p.quest_stage == 4:
			var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
			
			if mixer_stage == 0:
				if inv_ui and inv_ui.has_item("Life_Herb"):
					inv_ui.remove_item("Life_Herb")
					set_mixer_texture("res://assets/Ingredientmixer_LifeHerb.png")
					mixer_stage = 1
					show_dialog("ใส่ Life Herb ลงไปแล้ว! ต่อไปต้องใส่ Bloodmoon Mushroom")
				else:
					show_dialog("ต้องใส่ Life Herb เป็นอันดับแรก!")
					
			elif mixer_stage == 1:
				if inv_ui and inv_ui.has_item("BloodmoonMushroom"):
					inv_ui.remove_item("BloodmoonMushroom")
					set_mixer_texture("res://assets/Ingredientmixer_LifeHerb_Mushroom.png")
					mixer_stage = 2
					show_dialog("ใส่เห็ดลงไปแล้ว! สุดท้ายต้องใส่ Soul Crystal")
				else:
					show_dialog("ต้องใส่ Bloodmoon Mushroom เป็นอันดับต่อไป!")
					
			elif mixer_stage == 2:
				if inv_ui and inv_ui.has_item("SoulCrystal"):
					inv_ui.remove_item("SoulCrystal")
					set_mixer_texture("res://assets/Ingredientmixer_LifeHerb_Mushroom_Crystal.png")
					mixer_stage = 3
					show_dialog("ใส่ส่วนผสมครบแล้ว! กด E อีกครั้งเพื่อเริ่มเครื่องผสมยา")
				else:
					show_dialog("ต้องใส่ Soul Crystal เป็นอันดับสุดท้าย!")
					
			elif mixer_stage == 3:
				is_mixing = true
				mixer_stage = 4
				show_dialog("เครื่องกำลังสกัดยา... โปรดรอสักครู่")
				
				await get_tree().create_timer(3.0).timeout
				
				is_mixing = false
				set_mixer_texture("res://assets/Ingredientmixer.png") # กลับเป็นสภาพเครื่องเปล่า
					
				if inv_ui:
					inv_ui.add_item("RevivalPotion")
				if is_instance_valid(p):
					p.quest_stage = 5
					p.update_quest_ui()
				show_dialog("ผสมยาสำเร็จ! ได้ Revival Potion มาแล้ว รีบเอาไปให้ Hena เถอะ!")

func _on_body_entered(body):
	if body.name == "player":
		player_node = body

func _on_body_exited(body):
	if body.name == "player":
		player_node = null
