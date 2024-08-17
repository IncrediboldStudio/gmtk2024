extends Block

class_name Threadmill

var speed = 40
var remove_first_component = false

func move(delta):
    if next_block == null || components_contained.size() == 0:
        return
    
    var next_stop = 200
    if next_block.components_contained.size() != 0:
        next_stop = 100 + next_block.components_contained[-1][1]
    var free_space = next_stop - components_contained[0][1] - components_contained[0][0].size_in_block_ratio
    var move = clampf(free_space, 0, speed * delta)
    for i in components_contained.size():
        components_contained[0][1] += move
        if components_contained[0][1] >= 100:
            components_contained[0][1] -= 100
            next_block.receive(components_contained[0])
            remove_first_component = true
        
    if (remove_first_component):
        components_contained.pop_front()
        remove_first_component = false


func receive(component_and_position):
    components_contained.append(component_and_position)
