import io
with io.open('scenes/interactables/ingredient_mixer.gd', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('"UI/Inventory"', '"UI/InventoryUI"')
content = content.replace('for child in inventory_ui.get_children():', 'for child in inventory_ui.grid.get_children():')
content = content.replace('inventory_ui.add_child(potion_slot)', 'inventory_ui.grid.add_child(potion_slot)')

with io.open('scenes/interactables/ingredient_mixer.gd', 'w', encoding='utf-8') as f:
    f.write(content)