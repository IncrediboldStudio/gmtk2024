extends Conveyor

class_name Assembler

var onlyOnce = false
func move(delta):
    if components_contained.size() != 0 && (components_contained[0][0].generated_by == self || components_contained[0][1] < 50):
        super(delta)
        return;
    
    if sub_block.components_contained.size() == 0 || sub_block.components_contained[0][1] < 50:
        return
        
    onlyOnce = true
    
    var components_parent = components_contained[0][0].get_parent()
    var components_to_assemble: Array[Component]
    components_to_assemble.append(components_contained[0][0])
    components_to_assemble.append(sub_block.components_contained[0][0])
    var new_component_data = RecipeManager.GetAssemblyResult(components_to_assemble)
    components_contained.pop_front()[0].queue_free()
    sub_block.components_contained.pop_front()[0].queue_free()
    
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    components_parent.add_child(instance)
    instance.component_data = new_component_data
    instance.global_position = global_position
    instance.generated_by = self
    components_contained.push_front([instance, 50])
