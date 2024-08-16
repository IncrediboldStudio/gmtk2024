extends Block

class_name threadmill

func send():
    if next_block == null:
        return
        
    if next_block.receive(components_contained):
        components_contained = null


func receive(components) -> bool:
    if components_contained != null:
        return false
    
    components_contained = components
    return true;
