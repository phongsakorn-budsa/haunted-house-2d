import io
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

start_idx = content.find('[node name="Inventory" type="HBoxContainer" parent="UI"')
if start_idx != -1:
    end_idx = content.find('[node name="HealthUI"', start_idx)
    if end_idx != -1:
        # Replace the old Inventory block with just empty string
        content = content[:start_idx] + content[end_idx:]
        
        with io.open('world.tscn', 'w', encoding='utf-8') as f:
            f.write(content)
        print("Removed old Inventory node")