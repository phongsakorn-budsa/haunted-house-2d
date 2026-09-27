import io
with io.open('world.tscn', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('[node name="Background" type="ColorRect"', '[node name="Background" type="ColorRect"\nz_index = -100')

with io.open('world.tscn', 'w', encoding='utf-8') as f:
    f.write(content)