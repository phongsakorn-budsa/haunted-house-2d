import io
import re
with io.open('boss_room.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r'(\[node name="Bossfight" type="Sprite2D"[^\]]*\])', r'\1\nz_index = -10', content)

with io.open('boss_room.tscn', 'w', encoding='utf-8') as f:
    f.write(content)