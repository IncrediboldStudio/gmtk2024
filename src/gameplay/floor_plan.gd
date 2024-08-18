extends Node

var width
var height
var blocks = []

@export var testing: bool = false

func _ready():
    if (testing):
        setup_test_scenario()
    

func _process(delta):
    if (testing):
        process_test_scenario(delta)
    

func setup(new_width, new_height):
    width = new_width
    height = new_height
    for i in width:
        blocks.append([])
        for j in height:
            blocks[i].append(Block.new())
            if (testing):
                blocks[i][j].position = Vector2(i,j) * 200 + Vector2(100, 100)


func add(new_block: Block, position: Vector2, entry: Vector2, exit: Vector2):
    blocks[position.x][position.y].queue_free()
    blocks[position.x][position.y] = new_block
    new_block.position = position * 200 + Vector2(100, 100)
    new_block.exit_direction = exit
    
    var adjacent_block_position = position + entry
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        var previous_block = blocks[adjacent_block_position.x][adjacent_block_position.y]
        if previous_block.next_block == null || previous_block.next_block.get_script().get_global_name() == "Block":
            new_block.previous_block = previous_block
            previous_block.next_block = new_block
            new_block.distance_to_adjacent = (new_block.position - previous_block.position).length()
    
    adjacent_block_position = position + exit
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        var next_block = blocks[adjacent_block_position.x][adjacent_block_position.y]
        if (next_block.previous_block == null || next_block.previous_block.get_script().get_global_name() == "Block"):
            new_block.next_block = next_block
            next_block.previous_block = new_block
            new_block.distance_to_adjacent = (new_block.position - next_block.position).length()
        
        
func remove(position: Vector2):
    blocks[position.x][position.y].queue_free()
    blocks[position.x][position.y] = Block.new()


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
    blocks[0][0].next_block = asem.entrys[0]
    blocks[1][0].next_block = asem.entrys[1]
    asem.exits.append(Block.new())
    asem.exits[0].position = Vector2(100, 300)
    asem.exits[0].next_block = blocks[0][2]
    
    var new_component = preload("res://src/gameplay/component/Component.tscn")
    var instance = new_component.instantiate()
    var component_data = preload("res://src/gameplay/component/test_component.tres")
    add_child(instance)
    var instance2 = instance.duplicate()
    add_child(instance2)
    instance.component_data = component_data
    instance2.component_data = component_data
    
    blocks[0][0].receive(instance)
    blocks[2][0].receive(instance2)


func process_test_scenario(delta):
    for i in width:
        for j in height:
            blocks[i][j].work(delta)
