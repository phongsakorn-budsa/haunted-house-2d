import io
with io.open('scenes/ememy/boss_hena.gd', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('@onready var sprite = \n', '@onready var sprite = \n')

with io.open('scenes/ememy/boss_hena.gd', 'w', encoding='utf-8') as f:
    f.write(content)