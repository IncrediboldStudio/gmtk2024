extends Block

class_name Manipulator

var entrys: Array[Entry]
var exits: Array[Block]

var floor_plan: FloorPlan

var work_complete = false
var work_time = 0
func work(delta):
    if (work_time == 0):
        for entry in entrys:
            if entry.held_component == null:
                return
    
    work_time += delta
    if work_time > 2:
        work_complete = true


func send_to_next(components: Array[Component]):
    for i in components.size():
        if (i >= exits.size()):
            break
        var destination = exits[i].next_block
        if destination is Conveyor:
            components[i].global_position = exits[i].position
            destination.receive_from_manipulator(components[i])
        else:
            destination.receive(components[i])
    
    work_time = 0
    work_complete = false
    
