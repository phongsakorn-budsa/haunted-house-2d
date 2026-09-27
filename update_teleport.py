import io
import re
with io.open('scenes/interactables/hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

# Change teleport offset
content = content.replace('p.global_position = boss_room.global_position + Vector2(0, 150)', 'p.global_position = boss_room.global_position + Vector2(400, 480)')

with io.open('scenes/interactables/hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)