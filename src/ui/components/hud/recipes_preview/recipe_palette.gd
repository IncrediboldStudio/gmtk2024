extends Control

@export var recipe_containers: Array[RecipeContainer]
@export var master_recipe_list: MasterRecipeList

func _ready():
	EventEngine.update_target_components.connect(_on_update_recipes)

func _on_update_recipes(target_components):
	var i = 0
	for key in target_components:
		recipe_containers[i].visible = true
		var value = master_recipe_list.get_recipe_for_result(key)
		recipe_containers[i].set_value(value)
		i += 1
		
	for j in range(i,recipe_containers.size()):
		recipe_containers[j].visible = false
