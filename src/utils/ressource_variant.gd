@tool
extends Resource

class_name ResourceVariant

@export var parent_resource: Resource : set = _on_parent_changed

func _on_parent_changed(value : Resource):
    print("hello")
    parent_resource = value
    parent_resource.changed.connect(_on_parent_modified)

func _on_parent_modified():
    var parameters = parent_resource.get_script().get_script_property_list()
    print(parameters)
    for parameter in parameters:
        print(parameter)
        var parameter_name = parameter["name"]
        if parameter_name != "parent_resource":
            print(parameter_name)
            print(parent_resource.get(parameter_name))
            set(parameter_name, parent_resource.get(parameter_name))