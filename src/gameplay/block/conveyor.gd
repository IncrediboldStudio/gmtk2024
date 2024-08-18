extends Block

class_name Conveyor

var speed = 183

func work(delta):
    if components_contained.size() == 0 || components_contained[-1][0].is_blocked:
        return
    
    var next_stop
    var free_space
    var movement
    
    for i in components_contained.size():
        if (components_contained[i][0].is_blocked):
            continue
        
        if i == 0:
            next_stop = 200
            if next_block == null || next_block.next_block == self || (next_block is Entry && next_block.held_component != null):
                next_stop = 100
            elif next_block.components_contained.size() != 0:
                next_stop = 100 + next_block.components_contained[-1][1]
            free_space = next_stop - components_contained[0][1] - components_contained[0][0].base_data.size_in_block_ratio
        else:
            free_space = components_contained[i-1][1] - components_contained[i][1] - components_contained[i][0].base_data.size_in_block_ratio
        
        if (free_space == 0):
            if i == 0:
                if next_block == null:
                    components_contained[i][0].is_blocked = true
            elif components_contained[i-1][0].is_blocked:
                components_contained[i][0].is_blocked = true
            continue
        
        movement = clampf(free_space, 0, speed * delta)
        
        components_contained[i][1] += movement
        if (components_contained[i][1] < 50):
            components_contained[i][0].global_position = global_position + (distance_to_adjacent * (components_contained[i][0].global_position - global_position).normalized() * absf(components_contained[i][1] - 50) / 100)
        else:
            components_contained[i][0].global_position = global_position + (distance_to_adjacent * exit_direction * (components_contained[i][1] - 50) / 100)
    
    var limit = 100
    if next_block is not Conveyor:
        limit += components_contained[0][0].base_data.size_in_block_ratio / 2
    if components_contained[0][1] >= limit:
        components_contained[0][1] -= limit
        next_block.receive(components_contained[0][0])
        components_contained.pop_front()


func receive(component):
    components_contained.append([component, 0])


func receive_from_manipulator(component):
    components_contained.append([component, -component.base_data.size_in_block_ratio])
