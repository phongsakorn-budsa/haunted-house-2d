import io
with io.open('scenes/items/ingredient.gd', 'r', encoding='utf-8') as f:
    content = f.read()

target = 'if not (ingredient_name in body.inventory):'
replacement = 'var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")\n\t\tif not (inv_ui and inv_ui.has_item(ingredient_name)):'
content = content.replace(target, replacement)

with io.open('scenes/items/ingredient.gd', 'w', encoding='utf-8') as f:
    f.write(content)