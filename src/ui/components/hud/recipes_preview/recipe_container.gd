extends Control

class_name RecipeContainer

var texture_rect1: TextureRect
var texture_rect2: TextureRect
var texture_rect3: TextureRect
func _ready() -> void:
	texture_rect1 = get_node("MarginContainer/HBoxContainer/TextureRect")
	texture_rect2 = get_node("MarginContainer/HBoxContainer/TextureRect2")
	texture_rect3 = get_node("MarginContainer/HBoxContainer/TextureRect3")
	
func set_value(recipe_data : RecipeData):
	texture_rect1.texture = recipe_data.components[0].texture
	texture_rect2.texture = recipe_data.components[1].texture
	texture_rect3.texture = recipe_data.result.base_data.texture
