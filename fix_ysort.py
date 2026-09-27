import io
import re

with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

# Match nodes that are Floor or RedCarpet or Wall (basically any Sprite2D that isn't a character)
# Actually, the user has: RedCarpet, Floor, Wall (maybe?).
# Let's just find ALL Sprite2D nodes in world.tscn that are NOT Player, Zombie, Hena.
# Wait, the scene uses Sprite2D for floors.
# Let's add z_index = -5 to Floor and RedCarpet nodes.

def replace_z_index(match):
    node_decl = match.group(0)
    if 'z_index' not in node_decl:
        return node_decl + '\nz_index = -5'
    return node_decl

# Regex to match [node name="Floor..." type="Sprite2D"...]
content = re.sub(r'\[node name="(Floor|RedCarpet)[^"]*" type="Sprite2D"[^\]]*\]', replace_z_index, content)

# Enable Y-sort on the main World node
content = content.replace('[node name="World" type="Node2D"', '[node name="World" type="Node2D"\ny_sort_enabled = true')

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated world.tscn Y-sort and z_indexes")