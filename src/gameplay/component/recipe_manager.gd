extends Node

const recipes_list: RecipeListData = preload("res://src/gameplay/component/recipe_list.tres")


func _ready():
    for recipe in recipes_list.recipes:
        recipe.components.sort()

func GetAssemblyResult(components: Array[Component]):
    var components_types: Array[ComponentData.COMPONENT_TYPE]
    for component in components:
        components_types.append(component.component_data.type)
    components_types.sort()
        
    for recipe in recipes_list.recipes:
        if recipe.components == components_types:
            return recipe.result
    
    return null
