extends Node

class_name FloorPlan

const simulation_duration = 30

var time_since_start = 0
var width = 8
var height = 8
var simulated_blocks = []

var expected_components = {}
var expected_components_left = {}

var levels = []

@export var map: Map

var simulation_started = false
func _ready():
    EventEngine.run_simulation.connect(_on_run_simulation)
    EventEngine.upgrade_factory.connect(_on_upgrade_factory)
    levels.append(preload("res://src/gameplay/level/level_1.tres"))
    levels.append(preload("res://src/gameplay/level/level_2.tres"))
    levels.append(preload("res://src/gameplay/level/level_3.tres"))
    _on_upgrade_factory()

var current_level = -1
func _on_upgrade_factory():
    current_level += 1
    if current_level >= levels.size():
        EventEngine.you_win.emit()
    
    map.load_map(levels[current_level].blocks)
    expected_components = levels[current_level].expected_component
    EventEngine.update_target_components.emit(expected_components)
    

func _on_run_simulation():
    if !simulation_started:
        SfxManager.play_sfx(SfxManager.SfxName.FACTORY_ACTIVATION, SfxManager.SfxVariation.NONE)
        expected_components_left = expected_components.duplicate()
        run_simulation()
        simulation_started = true
        time_since_start = 0
        return
    
    stop_simulation()
        
        
func stop_simulation():
    SfxManager.play_sfx(SfxManager.SfxName.FACTORY_DESACTIVATION, SfxManager.SfxVariation.NONE)
    simulation_started = false
    for column in simulated_blocks:
        for block in column:
            if block != null:
                block.clean()
    simulated_blocks.clear()
    for child in get_children():
        remove_child(child)
        child.queue_free()
    EventEngine.update_target_components.emit(expected_components)
    EventEngine.stop_simulation.emit()
        
        
func on_simulation_complete():
    stop_simulation()
    

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
                    if next_block is Conveyor && next_block.grid_pos + next_block.block_data.inputs[0].pos != grid_pos:
                        continue
                    block.next_block = next_block
                    next_block.previous_block = block
        elif block is Producer:
            block.floor_plan = self
            simulated_blocks[grid_pos.x][grid_pos.y] = block
            var next_pos = grid_pos + block.block_data.outputs[0].pos
            if is_within_grid(next_pos) && simulated_blocks[next_pos.x][next_pos.y].get_script().get_global_name() != "Block":
                var next_block = get_block_at(next_pos, block.grid_pos)
                if next_block != null && next_block.get_script().get_global_name() != "Block":
                    if next_block is Conveyor && next_block.grid_pos + next_block.block_data.inputs[0].pos != grid_pos:
                        continue
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
                block.exits.append(Exit.new())
                var exit_pos = block.grid_pos + output.pos
                block.exits[i].position = (exit_pos - get_direction_vector(output.edge)) * 64
                if is_within_grid(exit_pos):
                    var next_block = get_block_at(exit_pos, exit_pos - get_direction_vector(output.edge))
                    if next_block != null && next_block.get_script().get_global_name() != "Block":
                        block.exits[i].next_block = next_block


func get_block_at(grid_pos: Vector2i, from_grid_pos: Vector2i):
    var block: Block = simulated_blocks[grid_pos.x][grid_pos.y]
    
    if block is Manipulator || block is Receiver:
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
        time_since_start += delta
        if time_since_start < simulation_duration:
            process_test_scenario(delta)
        else:
            on_simulation_complete()
    

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
            if simulated_blocks.size() == 0 || simulated_blocks[i][j] == null:
                return
            simulated_blocks[i][j].work(delta)
            
            
func component_received(component_base_data: ComponentBaseData):
    var value = expected_components_left.get(component_base_data)
    if value == null:
        return
    
    if value > 0:
        value -= 1
    
    if value == 0:
        var all_component_received = true
        for component in expected_components_left:
            if expected_components_left[component] != 0:
                all_component_received = false
                break
        if all_component_received:
            EventEngine.all_component_delivered.emit()
            SfxManager.play_sfx(SfxManager.SfxName.SUCCESS, SfxManager.SfxVariation.LOW)
            on_simulation_complete()
    
    expected_components_left[component_base_data] = value
    EventEngine.update_target_components.emit(expected_components_left)
