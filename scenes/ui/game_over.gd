extends ColorRect

func _ready():
	# เชื่อมต่อปุ่มเมื่อกดให้ไปทำงานที่ฟังก์ชัน _on_restart_pressed
	$RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	# ปลดล็อคเวลา (Unpause)
	get_tree().paused = false
	# เริ่มเกมใหม่ (โหลดฉากปัจจุบันใหม่)
	get_tree().reload_current_scene()
