import io
import re

with io.open('boss_room.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

# Add script resource
script_res = '[ext_resource type="Script" path="res://scenes/ememy/boss_hena.gd" id="3_boss"]\n'
content = content.replace('[node name="Node2D"', script_res + '[node name="Node2D"')

# Add capsule shape subresource
capsule_res = '[sub_resource type="CapsuleShape2D" id="CapsuleShape2D_boss"]\nradius = 80.0\nheight = 250.0\n\n'
content = content.replace('[node name="Node2D"', capsule_res + '[node name="Node2D"')

# Fix Z-index of Bossfight
content = content.replace('[node name="Bossfight" type="Sprite2D"', '[node name="Bossfight" type="Sprite2D"\nz_index = -10')

# Extract HenaDemon node to replace it dynamically
match = re.search(r'\[node name="HenaDemon" type="Sprite2D"[^\]]*\]\nposition = Vector2\([^\)]+\)\nscale = Vector2\([^\)]+\)\ntexture = ExtResource\([^\]]+\)', content)

if match:
    old_hena = match.group(0)
    lines = old_hena.split('\n')
    pos_line = [l for l in lines if l.startswith('position')][0]
    scale_line = [l for l in lines if l.startswith('scale')][0]
    tex_line = [l for l in lines if l.startswith('texture')][0]
    
    new_hena = f'''[node name="HenaDemon" type="CharacterBody2D" parent="." groups=["enemies"]]
{pos_line}
script = ExtResource("3_boss")

[node name="Sprite2D" type="Sprite2D" parent="HenaDemon"]
{scale_line}
{tex_line}

[node name="CollisionShape2D" type="CollisionShape2D" parent="HenaDemon"]
shape = SubResource("CapsuleShape2D_boss")

[node name="AttackTimer" type="Timer" parent="HenaDemon"]
wait_time = 1.0
one_shot = true'''
    
    content = content.replace(old_hena, new_hena)
    
    with io.open('boss_room.tscn', 'w', encoding='utf-8') as f:
        f.write(content)
    print("Successfully patched boss_room.tscn")
else:
    print("Could not find HenaDemon node pattern")