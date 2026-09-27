import io
import re
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the malformed Background node
content = re.sub(r'\[node name="Background" type="ColorRect"\n?z_index = -100\s*(parent="." unique_id=\d+)\]', r'[node name="Background" type="ColorRect" \1]\nz_index = -100', content)

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(content)