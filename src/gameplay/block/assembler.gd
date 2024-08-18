extends Manipulator

class_name Assembler

func work(delta):
    super(delta)
    if (!work_complete):
        return
    
    var components: Array[Component]
    for entry in entrys:
        components.append(entry.held_component)
        entry.held_component = null
    
    var components_parent = components[0].get_parent()
    var new_component_data = components[0].GetAssemblyResult(components)
    for component in components:
        component.queue_free()
        
    if new_component_data == null:
        return

    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    components_parent.add_child(instance)
    instance.component_data = new_component_data
    
    send_to_next([instance])
