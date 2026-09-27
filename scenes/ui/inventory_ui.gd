extends Control

@onready var bg = $Bg
@onready var grid = $Bg/GridContainer
@onready var equip_slot = $Bg/EquipSlot
@onready var hotbar = $HotbarContainer

func _ready():
	# ซ่อนกระเป๋าตอนเริ่มเกม แต่ Hotbar โชว์ตลอด
	bg.visible = false

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_TAB and not event.echo:
		bg.visible = !bg.visible

func get_all_slots() -> Array:
	var slots = []
	slots.append_array(hotbar.get_children())
	slots.append_array(grid.get_children())
	return slots

func add_item(item_name: String):
	# เช็คว่ามีซ้ำไหม
	for slot in get_all_slots():
		if slot.item_name == item_name:
			return true 
			
	# ยัดใส่ช่องว่าง (เริ่มจาก hotbar ก่อน)
	for slot in get_all_slots():
		if slot.item_name == "":
			slot.set_item(item_name)
			return true
	return false

func has_item(item_name: String) -> bool:
	if equip_slot.item_name == item_name: return true
	for slot in get_all_slots():
		if slot.item_name == item_name: return true
	return false

func remove_item(item_name: String):
	for slot in get_all_slots():
		if slot.item_name == item_name:
			slot.set_item("")
			return

func set_active_hotbar(index: int):
	var h_slots = hotbar.get_children()
	for i in range(h_slots.size()):
		h_slots[i].set_highlight(i == index)