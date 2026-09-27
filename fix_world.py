import io
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

target = '[node name="JumpscareEvent"'
if target in content:
    replacement = '[node name="InventoryUI" parent="UI" instance=ExtResource("17_invui")]\nvisible = false\n\n' + target
    content = content.replace(target, replacement)
    with io.open('world.tscn', 'w', encoding='utf-8') as f:
        f.write(content)
    print("Replaced successfully")
else:
    print("Target not found")