extends Block

class_name Receiver

var floor_plan: FloorPlan

var entrys: Array[Entry]
var exits: Array[Entry]

func on_setup_component_data():
    if block_data.component_data == null:
        return
        
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var preview = new_component.instantiate()
    preview.scale = Vector2(0.5, 0.5)
    add_child(preview)
    preview.component_data = block_data.component_data
    preview.sprite.offset = Vector2(64,64)

func work(_delta):
    for entry in entrys:
        if entry.held_component != null:
            if entry.held_component.component_data == block_data.component_data:
                floor_plan.component_received(entry.held_component.base_data)
            entry.held_component = null
        

func clean():
    super()
    entrys.clear()
