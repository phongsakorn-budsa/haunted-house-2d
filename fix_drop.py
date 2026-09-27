import io

def fix_file(path):
    with io.open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Replace check in drop logic
    content = content.replace('not ("Life_Herb" in p.inventory)', 'not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("Life_Herb"))')
    content = content.replace('not ("SoulCrystal" in p.inventory)', 'not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("SoulCrystal"))')
    content = content.replace('not ("BloodmoonMushroom" in p.inventory)', 'not (get_tree().current_scene.get_node_or_null("UI/InventoryUI") and get_tree().current_scene.get_node("UI/InventoryUI").has_item("BloodmoonMushroom"))')
    
    with io.open(path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_file('scenes/ememy/zombie.gd')
fix_file('scenes/ememy/ghost.gd')