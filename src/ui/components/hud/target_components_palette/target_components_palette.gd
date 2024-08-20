extends Control

@export var target_components_container: Array[TargetComponentsContainer]

func _ready():
    EventEngine.update_target_components.connect(_on_update_target_components)

func _on_update_target_components(target_components):
    var i = 0
    for key in target_components:
        var value = target_components[key]
        if value <= 0:
            target_components_container[i].visible = false
            continue
            
        target_components_container[i].visible = true
        target_components_container[i].set_value([key,value])
        i += 1
        
    for j in range(i,target_components_container.size()):
        target_components_container[j].visible = false
