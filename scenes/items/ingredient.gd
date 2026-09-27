extends Area2D

@export var ingredient_name: String = "Ingredient"

func _on_body_entered(body):
	if body.name == "player" and body.quest_stage == 4:
		var inv_ui = get_tree().current_scene.get_node_or_null("UI/InventoryUI")
		if not (inv_ui and inv_ui.has_item(ingredient_name)):
			body.ingredients_collected += 1
			body.pickup_item(ingredient_name)
			print("Picked up: ", ingredient_name, " Total: ", body.ingredients_collected)
			body.update_quest_ui()
		queue_free()