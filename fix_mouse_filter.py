import io
with io.open('scenes/ui/inventory_ui.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('[node name="HotbarContainer" type="HBoxContainer" parent="."]', '[node name="HotbarContainer" type="HBoxContainer" parent="."]\nmouse_filter = 2')

with io.open('scenes/ui/inventory_ui.tscn', 'w', encoding='utf-8') as f:
    f.write(content)