import io
with io.open('scenes/player/player.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Add selected_hotbar_index
content = content.replace('var quest_stage: int = 0', 'var quest_stage: int = 0\nvar selected_hotbar_index: int = 0')

# Update update_equipment
update_equip = '''func update_equipment():
	var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
	if inv_ui:
		var equip_slot = inv_ui.get_node("Bg/EquipSlot")
		
		if equip_slot.item_name == "Flashlight":
			if has_node("PointLight2D"):
				.enabled = true
				.scale = Vector2(20, 20)
		else:
			if has_node("PointLight2D"):
				.enabled = false
		
		var hotbar = inv_ui.get_node("HotbarContainer")
		var active_slot = hotbar.get_child(selected_hotbar_index)
		
		has_gun = (active_slot.item_name == "Gun")
		
		if has_gun:
			if has_node("WeaponPivot"):
				.visible = true
		else:
			if has_node("WeaponPivot"):
				.visible = false
				
		inv_ui.set_active_hotbar(selected_hotbar_index)
				
	update_ammo_ui()
'''

old_update_equip = '''func update_equipment():
	var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
	if inv_ui:
		var equip_slot = inv_ui.get_node("Bg/EquipSlot")
		
		if equip_slot.item_name == "Flashlight":
			if has_node("PointLight2D"):
				.enabled = true
				.scale = Vector2(20, 20)
		else:
			if has_node("PointLight2D"):
				.enabled = false
		
		has_gun = inv_ui.has_item("Gun")
		if has_gun:
			if has_node("WeaponPivot"):
				.visible = true
		else:
			if has_node("WeaponPivot"):
				.visible = false
				
	update_ammo_ui()
'''

content = content.replace(old_update_equip.strip(), update_equip.strip())

# Add input for 1,2,3,4
input_code = '''	if Input.is_key_pressed(KEY_1):
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
		
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")'''

content = content.replace('var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")', input_code)

with io.open('scenes/player/player.gd', 'w', encoding='utf-8') as f:
    f.write(content)