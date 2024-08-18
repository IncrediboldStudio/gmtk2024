extends Node

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
            if is_within_grid(next_pos):
                block.previous_block = simulated_blocks[next_pos.x][next_pos.y]
                simulated_blocks[next_pos.x][next_pos.y].next_block = block
                block.exit_direction = get_direction_vector(block.block_data.outputs[0].edge)
        #else:
        #    for pos in block.block_data.block_layout:
        #        simulated_blocks[grid_pos.x + pos.x][grid_pos.y + pos.y] = block
        #    for input in block.block_data.inputs:
                
            
            
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


func _ready():
    if (testing):
        setup_test_scenario()
    
var once = true
var patate = 0
func _process(delta):
    patate += delta
    #if (testing):
    if patate > 10:
        if once:
            run_simulation(map.blocks)
            var new_component = preload("res://src/gameplay/component/Component.tscn")
            var instance = new_component.instantiate()
            add_child(instance)
            var component_data = preload("res://src/gameplay/component/test_component.tres")
            instance.component_data = component_data
            simulated_blocks[0][1].receive(instance)
            once = false
        process_test_scenario(delta)
    

func setup(new_width, new_height):
    width = new_width
    height = new_height
    for i in width:
        simulated_blocks.append([])
        for j in height:
            simulated_blocks[i].append(Block.new())
            if (testing):
                simulated_blocks[i][j].position = Vector2(i,j) * 200 + Vector2(100, 100)


func add(new_block: Block, position: Vector2, entry: Vector2, exit: Vector2):
    simulated_blocks[position.x][position.y].queue_free()
    simulated_blocks[position.x][position.y] = new_block
    new_block.position = position * 200 + Vector2(100, 100)
    new_block.exit_direction = exit
    
    var adjacent_block_position = position + entry
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        var previous_block = simulated_blocks[adjacent_block_position.x][adjacent_block_position.y]
        if previous_block.next_block == null || previous_block.next_block.get_script().get_global_name() == "Block":
            new_block.previous_block = previous_block
            previous_block.next_block = new_block
    
    adjacent_block_position = position + exit
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        var next_block = simulated_blocks[adjacent_block_position.x][adjacent_block_position.y]
        if (next_block.previous_block == null || next_block.previous_block.get_script().get_global_name() == "Block"):
            new_block.next_block = next_block
            next_block.previous_block = new_block
        
        
func remove(position: Vector2):
    simulated_blocks[position.x][position.y].queue_free()
    simulated_blocks[position.x][position.y] = Block.new()


func setup_test_scenario():
    setup(3, 3)
    add(Conveyor.new(), Vector2(0,0), Vector2(0,-1), Vector2(0,1))
    add(Conveyor.new(), Vector2(1,0), Vector2(0,-1), Vector2(0,1))
    var asem = Assembler.new()
    add(asem, Vector2(0,1), Vector2(0,-1), Vector2(0,1))
    add(asem, Vector2(1,1), Vector2(0,-1), Vector2(0,1))
    add(Conveyor.new(), Vector2(0,2), Vector2(0,-1), Vector2(0,1))
    add(Conveyor.new(), Vector2(2,0), Vector2(0,1), Vector2(-1,0))
    
    asem.entrys.append(Entry.new())
    asem.entrys.append(Entry.new())
    simulated_blocks[0][0].next_block = asem.entrys[0]
    simulated_blocks[1][0].next_block = asem.entrys[1]
    asem.exits.append(Block.new())
    asem.exits[0].position = Vector2(100, 300)
    asem.exits[0].next_block = simulated_blocks[0][2]
    
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    var component_data = preload("res://src/gameplay/component/test_component.tres")
    add_child(instance)
    var instance2 = instance.duplicate()
    add_child(instance2)
    instance.component_data = component_data
    instance2.component_data = component_data
    
    simulated_blocks[0][0].receive(instance)
    simulated_blocks[2][0].receive(instance2)


func process_test_scenario(delta):
    for i in width:
        for j in height:
            simulated_blocks[i][j].work(delta)
