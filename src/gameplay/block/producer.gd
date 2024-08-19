extends Block

class_name Producer
var floor_plan: FloorPlan

func on_setup_component_data():
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var preview = new_component.instantiate()
    preview.scale = Vector2(0.5, 0.5)
    add_child(preview)
    preview.component_data = block_data.component_data
    preview.sprite.offset = Vector2(64,64)
    preview.sprite.z_index = 1
    

var work_complete = false
var work_time = 0
func work(delta):
    if (next_block == null):
        return
    
    work_time += delta
    if work_time > .2:
        generate_component()
        

func clean():
    super()
    work_complete = false
    work_time = 0

func generate_component():
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    floor_plan.add_child(instance)
    instance.component_data = block_data.component_data
    
    if next_block is Conveyor:
        instance.global_position = position
        next_block.receive_from_manipulator(instance)
    else:
        next_block.receive(instance)
    
    work_time = 0
    work_complete = false
