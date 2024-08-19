extends Control

class_name TargetComponentsContainer

var texture_rect: TextureRect
var label: Label
func _ready() -> void:
    texture_rect = get_node("MarginContainer/HBoxContainer/TextureRect")
    label = get_node("MarginContainer/HBoxContainer/Label")
    
func set_value(target_component):
    var component_base_data: ComponentBaseData = target_component[0]
    var component_count: int = target_component[1]
    
    texture_rect.texture = component_base_data.texture
    label.text = "x " + str(component_count)
