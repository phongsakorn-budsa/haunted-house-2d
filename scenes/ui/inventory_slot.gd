extends Panel

@export var is_equip_slot: bool = false
@export var hotbar_number: String = ""

var item_name: String = ""

@onready var icon = $Icon
@onready var number_label = $NumberLabel
@onready var highlight = $Highlight

func _ready():
	number_label.text = hotbar_number

func set_item(new_item_name: String):
	item_name = new_item_name
	if item_name == "":
		icon.texture = null
	else:
		if item_name == "Flashlight": icon.texture = load("res://assets/flashlight_sprite.png")
		elif item_name == "Gun": icon.texture = load("res://assets/gun1911.png")
		elif item_name == "Life_Herb": icon.texture = load("res://assets/Life_Herb.png")
		elif item_name == "SoulCrystal": icon.texture = load("res://assets/SoulCrystal.png")
		elif item_name == "BloodmoonMushroom": icon.texture = load("res://assets/BloodmoonMushroom.png")
		elif item_name == "RevivalPotion": icon.texture = load("res://assets/RevivalPotion.png")
		elif item_name == "Key": icon.texture = load("res://assets/key.png")

func set_highlight(active: bool):
	highlight.visible = active

func _get_drag_data(at_position):
	if item_name == "":
		return null
	
	var preview = TextureRect.new()
	preview.texture = icon.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = Vector2(60, 60)
	preview.modulate = Color(1, 1, 1, 0.7)
	
	var control = Control.new()
	control.add_child(preview)
	preview.position = -preview.custom_minimum_size / 2
	
	set_drag_preview(control)
	return {"type": "item", "item_name": item_name, "origin": self}

func _can_drop_data(at_position, data):
	if typeof(data) == TYPE_DICTIONARY and data.has("type") and data["type"] == "item":
		if is_equip_slot:
			return data["item_name"] == "Flashlight"
		return true
	return false

func _drop_data(at_position, data):
	var origin_slot = data["origin"]
	var dragged_item = data["item_name"]
	
	var temp_item = item_name
	origin_slot.set_item(temp_item)
	set_item(dragged_item)
	
	var player = get_tree().current_scene.get_node_or_null("player")
	if player and player.has_method("update_equipment"):
		player.update_equipment()