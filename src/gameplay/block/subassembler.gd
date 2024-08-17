extends Conveyor

class_name SubAssembler

func move(delta):
    if components_contained.size() != 0 && components_contained[0][1] < 50:
        super(delta)
        return;
