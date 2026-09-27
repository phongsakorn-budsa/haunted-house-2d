import io
with io.open('scenes/player/player.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

ammo_node = '''
[node name="AmmoLabel" type="Label" parent="."]
offset_left = -20.0
offset_top = -60.0
offset_right = 20.0
offset_bottom = -37.0
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_constants/outline_size = 4
theme_override_font_sizes/font_size = 14
text = "7/7"
horizontal_alignment = 1
'''

if "[node name=\"AmmoLabel\"" not in content:
    content += ammo_node
    with io.open('scenes/player/player.tscn', 'w', encoding='utf-8') as f:
        f.write(content)