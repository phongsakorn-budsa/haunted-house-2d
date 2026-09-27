import io
import re

with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

old_shapes = '''	var shapes = [
		{"pos": Vector2(430, 320), "size": Vector2(1400, 50)}, # บน
		{"pos": Vector2(430, 650), "size": Vector2(1400, 50)}, # ล่าง
		{"pos": Vector2(-150, 450), "size": Vector2(50, 800)}, # ซ้าย
		{"pos": Vector2(1050, 450), "size": Vector2(50, 800)}  # ขวา
	]'''

new_shapes = '''	var shapes = [
		{"pos": Vector2(430, 200), "size": Vector2(1800, 50)}, # บน (ขยับขึ้นไปเยอะขึ้น)
		{"pos": Vector2(430, 750), "size": Vector2(1800, 50)}, # ล่าง (ขยับลงมาเยอะขึ้น)
		{"pos": Vector2(-300, 450), "size": Vector2(50, 1000)}, # ซ้าย (ขยับออกไปกว้างขึ้น)
		{"pos": Vector2(1200, 450), "size": Vector2(50, 1000)}  # ขวา (ขยับออกไปกว้างขึ้น)
	]'''

content = content.replace(old_shapes, new_shapes)

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)