extends Block

class_name Receiver

var floor_plan: FloorPlan

var entrys: Array[Entry]
var exits: Array[Entry]

func work(_delta):
    for entry in entrys:
        if entry.held_component != null:
            var value = floor_plan.produced_component.get_or_add(entry.held_component.component_data, 0)
            floor_plan.produced_component[entry.held_component.component_data] = value + 1
            entry.held_component = null
        

func clean():
    super()
    entrys.clear()
