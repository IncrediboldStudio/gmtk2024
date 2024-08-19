extends Manipulator

class_name Assembler

func work(delta):
    super(delta)
    if (!work_complete || is_blocked || components_to_send.size() != 0):
        return
    
    var components: Array[Component]
    for entry in entrys:
        components.append(entry.held_component)
    
    if components.size() == 0:
        for entry in entrys:
            entry.held_component == null
        return
    
    var new_component_data = components[0].GetAssemblyResult(components)
    for component in components:
        component.queue_free()
        
    if new_component_data == null:
        work_time = 0
        work_complete = false
        return

    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    instance.visible = false
    floor_plan.add_child(instance)
    instance.component_data = new_component_data
    
    components_to_send = [instance]
    send_to_next()
