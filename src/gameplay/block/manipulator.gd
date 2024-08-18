extends Block

class_name Manipulator

var entrys: Array[Entry]
var exits: Array[Block]

var floor_plan: FloorPlan

var work_complete = false
var work_time = 0
var components_to_send: Array[Component]
var is_blocked = false

func work(delta):
    if is_blocked:
        return

    if components_to_send.size() != 0:
        send_to_next()

    if (work_time == 0):
        for entry in entrys:
            if entry.held_component == null:
                return
    
    work_time += delta
    if work_time > 0.5:
        work_complete = true
   

func clean():
    super()
    entrys.clear()
    exits.clear()
    work_complete = false
    work_time = 0
    components_to_send.clear()
    is_blocked = false


func send_to_next():
    if components_to_send.size() != exits.size():
        return
    
    for exit in exits:
        if exit.next_block == null || (exit.next_block is not Entry && exit.next_block.block_data == null):
            is_blocked = true
            return
        elif exit.next_block is Conveyor:
            if exit.next_block.components_contained.size() != 0 && exit.next_block.components_contained[-1][1] < 0:
                is_blocked = exit.next_block.components_contained[-1][0].is_blocked
                return
        elif exit.next_block is Entry:
            if exit.next_block.held_component != null:
                return
            
    for i in components_to_send.size():
        components_to_send[i].visible = true
        var destination = exits[i].next_block
        if destination is Conveyor:
            components_to_send[i].global_position = exits[i].global_position
            destination.receive_from_manipulator(components_to_send[i])
        else:
            destination.receive(components_to_send[i])
    
    for entry in entrys:
        entry.held_component = null
    
    work_time = 0
    work_complete = false
    components_to_send.clear()
