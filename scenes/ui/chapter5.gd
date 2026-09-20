extends Control

@onready var label = $TextBox/Label
var tween: Tween

func _ready():
	if label:
		var total_chars = label.text.length()
		label.visible_characters = 0
		tween = create_tween()
		var duration = total_chars / 15.0 # ความเร็วในการพิมพ์
		tween.tween_property(label, "visible_characters", total_chars, duration)

func _on_next_button_pressed():
	# ถ้าข้อความยังแสดงไม่จบ แล้วผู้เล่นใจร้อนกดปุ่ม
	# ให้แสดงข้อความทั้งหมดทันที
	if label and label.visible_characters < label.text.length():
		if tween:
			tween.kill()
		label.visible_characters = label.text.length()
	else:
		get_tree().change_scene_to_file("res://world.tscn")