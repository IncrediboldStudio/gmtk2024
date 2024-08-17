extends Node2D

class_name Component

var sprite : Sprite2D

var component_data : ComponentData : set = _set_component_data

var generated_by: Block
var is_blocked = false

func _ready():
    sprite = get_node("Sprite2D")

func _set_component_data(value):
    component_data = value
    sprite.texture = component_data.texture
    sprite.offset = component_data.texture_offset
