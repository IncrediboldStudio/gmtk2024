extends Block

class_name Producer

var component_data: ComponentData
var floor_plan: FloorPlan

var work_complete = false
var work_time = 0
func work(delta):
    if (next_block == null):
        return
    
    work_time += delta
    if work_time > 1:
        generate_component()


func generate_component():
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    floor_plan.add_child(instance)
    instance.component_data = component_data
    
    if next_block is Conveyor:
        instance.global_position = position
        next_block.receive_from_manipulator(instance)
    else:
        next_block.receive(instance)
    
    work_time = 0
    work_complete = false
