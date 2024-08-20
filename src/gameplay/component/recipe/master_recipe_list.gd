extends Resource

class_name MasterRecipeList

@export var recipes : Array[RecipeData]

func get_recipe_for_result(component : ComponentBaseData):
	for recipe in recipes:
		if recipe.result.base_data == component:
			return recipe
