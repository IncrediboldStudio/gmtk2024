extends Block

class_name Threadmill

var speed = 30

func move(delta):
    if next_block == null || components_contained.size() == 0:
        return
    
    var next_stop
    var free_space
    var movement
    
    for i in components_contained.size():
        if i == 0:
            next_stop = 200
            if next_block.components_contained.size() != 0:
                next_stop = 100 + next_block.components_contained[-1][1]
            free_space = next_stop - components_contained[0][1] - components_contained[0][0].size_in_block_ratio
        else:
            free_space = components_contained[i-1][1] - components_contained[i][1] - components_contained[i][0].size_in_block_ratio
            
        movement = clampf(free_space, 0, speed * delta)
        
        components_contained[i][1] += movement
        if (components_contained[i][1] < 50):
            components_contained[i][0].position = position + ((position - next_block.position).length() * (components_contained[i][0].position - position).normalized() * absf(components_contained[i][1] - 50) / 100)
        else:
            components_contained[i][0].position = position + ((next_block.position - position) * (components_contained[i][1] - 50) / 100)
        
    if components_contained[0][1] >= 100:
        components_contained[0][1] -= 100
        next_block.receive(components_contained[0])
        components_contained.pop_front()


func receive(component_and_position):
    components_contained.append(component_and_position)
