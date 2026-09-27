import io
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('[node name="InventoryUI" parent="UI" instance=ExtResource("17_invui")]\nvisible = false', '[node name="InventoryUI" parent="UI" instance=ExtResource("17_invui")]')

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(content)