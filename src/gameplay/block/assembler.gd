extends Conveyor

class_name Assembler

const result = preload("res://src/gameplay/component/Component-Combined.tscn")

var onlyOnce = false
func move(delta):
    if components_contained.size() != 0 && (components_contained[0][0].generated_by == self || components_contained[0][1] < 50):
        super(delta)
        return;
    
    if sub_block.components_contained.size() == 0 || sub_block.components_contained[0][1] < 50:
        return
        
    onlyOnce = true
    
    var components_parent = components_contained[0][0].get_parent()
    components_contained.pop_front()[0].queue_free()
    sub_block.components_contained.pop_front()[0].queue_free()
    var new_component = result.instantiate()
    new_component.generated_by = self
    new_component.global_position = global_position
    components_parent.add_child(new_component)
    components_contained.push_front([new_component as Component, 50])
