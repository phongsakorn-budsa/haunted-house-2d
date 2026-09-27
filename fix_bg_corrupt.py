import io
import re
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the malformed Background node
content = content.replace('[node name="Background" type="ColorRect"\\nz_index = -100 parent="." unique_id=365489591]', '[node name="Background" type="ColorRect" parent="." unique_id=365489591]\\nz_index = -100')

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(content)