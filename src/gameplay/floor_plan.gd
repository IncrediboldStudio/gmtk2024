extends Node

class_name FloorPlan

var width
var height
var simulated_blocks = []

@export var testing: bool = false
@export var map: Map

func run_simulation(blocks: Array[Block]):
    setup(8,8)
    for block in blocks:
        var grid_pos = block.grid_pos
        if block is Conveyor:
            simulated_blocks[grid_pos.x][grid_pos.y] = block
            var previous_pos = grid_pos + block.block_data.inputs[0].pos
            if is_within_grid(previous_pos):
                block.previous_block = simulated_blocks[previous_pos.x][previous_pos.y]
                simulated_blocks[previous_pos.x][previous_pos.y].next_block = block
            var next_pos = grid_pos + block.block_data.outputs[0].pos
            if is_within_grid(next_pos) && simulated_blocks[next_pos.x][next_pos.y].get_script().get_global_name() != "Block":
                block.next_block = simulated_blocks[next_pos.x][next_pos.y]
                simulated_blocks[next_pos.x][next_pos.y].previous_block = block
                block.exit_direction = get_direction_vector(block.block_data.outputs[0].edge)
        elif block is Producer:
            simulated_blocks[grid_pos.x][grid_pos.y] = block
            var next_pos = grid_pos + block.block_data.outputs[0].pos
            if is_within_grid(next_pos) && simulated_blocks[next_pos.x][next_pos.y].get_script().get_global_name() != "Block":
                block.next_block = simulated_blocks[next_pos.x][next_pos.y]
                simulated_blocks[next_pos.x][next_pos.y].previous_block = block
        else:
            for pos in block.block_data.block_layout:
                simulated_blocks[grid_pos.x + pos.x][grid_pos.y + pos.y] = block
            for i in block.block_data.inputs.size():
                var input = block.block_data.inputs[i]
                block.floor_plan = self
                block.entrys.append(Entry.new())
                var entry_pos = block.grid_pos + input.pos
                if is_within_grid(entry_pos):
                    simulated_blocks[entry_pos.x][entry_pos.y].next_block = block.entrys[i]
            for i in block.block_data.outputs.size():
                var output = block.block_data.outputs[i]
                block.exits.append(Block.new())
                var exit_pos = block.grid_pos + output.pos
                block.exits[i].position = exit_pos - get_direction_vector(output.Direction)
                if is_within_grid(exit_pos):
                    block.exits[i].next_block = simulated_blocks[exit_pos.x][exit_pos.y]
                
    
    #var ass = Assembler.new()
    #simulated_blocks[0][3] = ass
    #simulated_blocks[1][3] = ass
    #ass.floor_plan = self
    #ass.entrys.append(Entry.new())
    #ass.entrys.append(Entry.new())
    #simulated_blocks[0][2].next_block = ass.entrys[0]
    #simulated_blocks[1][2].next_block = ass.entrys[1]
    #ass.exits.append(Block.new())
    #ass.exits[0].position = Vector2(0, 192)
    #ass.exits[0].next_block = simulated_blocks[0][4]
    
    #var prod = Producer.new()
    #prod.component_data = preload("res://src/gameplay/component/test_component.tres")
    #prod.floor_plan = self
    #prod.next_block = simulated_blocks[0][1]
    #simulated_blocks[0][0] = prod
    #var prod2 = Producer.new()
    #prod2.component_data = preload("res://src/gameplay/component/test_component.tres")
    #prod2.floor_plan = self
    #prod2.next_block = simulated_blocks[1][1]
    #prod2.position = Vector2(64, 0)
    #simulated_blocks[1][0] = prod2
    
            
            
func is_within_grid(position: Vector2i):
    if (position.x < 0):
        return false
    if (position.x >= width):
        return false
    if (position.y < 0):
        return false
    if (position.y >= height):
        return false
    return true
    

func get_direction_vector(direction : BlockIO.Direction):
    if direction == BlockIO.Direction.RIGHT:
        return Vector2i(1,0)
    elif direction == BlockIO.Direction.LEFT:
        return Vector2i(-1,0)
    elif direction == BlockIO.Direction.DOWN:
        return Vector2i(0,1)
    elif direction == BlockIO.Direction.UP:
        return Vector2i(0,-1)
        
    
#var once = true
#var patate = 0
#func _process(delta):
#    patate += delta
#    #if (testing):
#    if patate > 10:
#        if once:
#            run_simulation(map.blocks)
#            var new_component = preload("res://src/gameplay/component/Component.tscn")
#            var instance = new_component.instantiate()
#            add_child(instance)
#            var component_data = preload("res://src/gameplay/component/test_component.tres")
#            instance.component_data = component_data
#            once = false
#        process_test_scenario(delta)
    

func setup(new_width, new_height):
    width = new_width
    height = new_height
    for i in width:
        simulated_blocks.append([])
        for j in height:
            simulated_blocks[i].append(Block.new())
            if (testing):
                simulated_blocks[i][j].position = Vector2(i,j) * 200 + Vector2(100, 100)


func process_test_scenario(delta):
    for i in width:
        for j in height:
            simulated_blocks[i][j].work(delta)
