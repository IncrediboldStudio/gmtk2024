extends Block

class_name threadmill

func send():
    if next_block == null || received_now:
        return
        
    if next_block.receive(components_contained):
        components_contained = 0


func receive(components) -> bool:
    if components_contained != 0:
        return false
    
    components_contained = components
    received_now = true
    return true;
