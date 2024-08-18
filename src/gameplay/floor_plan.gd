extends Node

class_name FloorPlan

var width = 8
var height = 8
var simulated_blocks = []

@export var map: Map

var simulation_started = false
func _ready():
    EventEngine.run_simulation.connect(_on_run_simulation)

func _on_run_simulation():
    if !simulation_started:
        run_simulation()
        simulation_started = true
        return
    
    simulation_started = false
    for column in simulated_blocks:
        for block in column:
            if block != null:
                block.clean()
    simulated_blocks.clear()
    for child in get_children():
        remove_child(child)
        child.queue_free()
    

func run_simulation():
    setup(map.map_size)
    for block in map.blocks:
        if block == null:
            continue
        
        var grid_pos = block.grid_pos
        if block is Conveyor:
            simulated_blocks[grid_pos.x][grid_pos.y] = block
            block.exit_direction = get_direction_vector(block.block_data.outputs[0].edge)
            var previous_pos = grid_pos + block.block_data.inputs[0].pos
            if is_within_grid(previous_pos):
                var previous_block = get_block_at(previous_pos, block.grid_pos)
                if previous_block != null:
                    block.previous_block = previous_block
                    previous_block.next_block = block
            var next_pos = grid_pos + block.block_data.outputs[0].pos
            if is_within_grid(next_pos):
                var next_block = get_block_at(next_pos, block.grid_pos)
                if next_block != null && next_block.get_script().get_global_name() != "Block":
                    block.next_block = next_block
                    next_block.previous_block = block
        elif block is Producer:
            block.component_data = preload("res://src/gameplay/component/test_component.tres")
            block.floor_plan = self
            simulated_blocks[grid_pos.x][grid_pos.y] = block
            var next_pos = grid_pos + block.block_data.outputs[0].pos
            if is_within_grid(next_pos) && simulated_blocks[next_pos.x][next_pos.y].get_script().get_global_name() != "Block":
                var next_block = get_block_at(next_pos, block.grid_pos)
                if next_block != null && next_block.get_script().get_global_name() != "Block":
                    block.next_block = next_block
                    next_block.previous_block = block
        else:
            block.floor_plan = self
            for pos in block.block_data.block_layout:
                simulated_blocks[grid_pos.x + pos.x][grid_pos.y + pos.y] = block
            for i in block.block_data.inputs.size():
                var input = block.block_data.inputs[i]
                block.floor_plan = self
                block.entrys.append(Entry.new())
                var entry_pos = block.grid_pos + input.pos
                if is_within_grid(entry_pos):
                    var previous_block = get_block_at(entry_pos, entry_pos + get_direction_vector(input.edge))
                    if previous_block != null && previous_block.get_script().get_global_name() != "Block":
                        previous_block.next_block = block.entrys[i]
            for i in block.block_data.outputs.size():
                var output = block.block_data.outputs[i]
                block.exits.append(Block.new())
                var exit_pos = block.grid_pos + output.pos
                block.exits[i].position = (exit_pos - get_direction_vector(output.edge)) * 64
                if is_within_grid(exit_pos):
                    var next_block = get_block_at(exit_pos, exit_pos - get_direction_vector(output.edge))
                    if next_block != null && next_block.get_script().get_global_name() != "Block":
                        block.exits[i].next_block = next_block


func get_block_at(grid_pos: Vector2i, from_grid_pos: Vector2i):
    var block: Block = simulated_blocks[grid_pos.x][grid_pos.y]
    
    if block is Manipulator:
        for i in block.block_data.inputs.size():
            var input = block.block_data.inputs[i]
            if block.grid_pos + input.pos == from_grid_pos:
                return block.entrys[i]
            
        for i in block.block_data.outputs.size():
            var output = block.block_data.outputs[i]
            if block.grid_pos + output.pos == from_grid_pos:
                return block.exits[i]
    elif block is Producer:
        if from_grid_pos == block.grid_pos + block.block_data.outputs[0].pos:
            return block
        else:
            return null
    else:
        return block
            
            
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
        

func _process(delta):
    if simulation_started:
        process_test_scenario(delta)
    

func setup(grid_size: Vector2i):
    width = grid_size.x
    height = grid_size.y
    for i in width:
        simulated_blocks.append([])
        for j in height:
            simulated_blocks[i].append(Block.new())


func process_test_scenario(delta):
    for i in width:
        for j in height:
            if simulated_blocks[i][j] == null:
                return
            simulated_blocks[i][j].work(delta)
