extends Node2D

class_name Component

var sprite : Sprite2D

var component_data : ComponentData : set = _set_component_data
var base_data
var recipes: Array[RecipeData]

var generated_by: Block
var is_blocked = false

func _ready():
    sprite = get_node("Sprite2D")

func _set_component_data(value):
    component_data = value
    base_data = component_data.base_data
    sprite.texture = base_data.texture
    
    if (component_data.recipe_list == null):
        return
    recipes = component_data.recipe_list.recipes
        
    for recipe in recipes:
        recipe.components.sort()


func GetAssemblyResult(components: Array[Component]):
    if (recipes.size() == 0):
        return null
        
    var components_base_data: Array[ComponentBaseData]
    for component in components:
        components_base_data.append(component.base_data)
    components_base_data.sort()
        
    for recipe in recipes:
        if recipe.components == components_base_data:
            return recipe.result
    
    return null
