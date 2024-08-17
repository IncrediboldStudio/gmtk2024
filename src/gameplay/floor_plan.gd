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


func add(new_block: Block, position: Vector2, entry: Vector2, exit: Vector2):
    blocks[position.x][position.y].queue_free()
    blocks[position.x][position.y] = new_block
    
    var adjacent_block_position = position + entry
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        blocks[adjacent_block_position.x][adjacent_block_position.y].next_block = new_block
    
    adjacent_block_position = position + exit
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        new_block.next_block = blocks[adjacent_block_position.x][adjacent_block_position.y]
        
        
func remove(position: Vector2):
    blocks[position.x][position.y].queue_free()
    blocks[position.x][position.y] = Block.new()


func print_blocks():
    var row
    for i in height:
        row = ""
        for j in width:
            if blocks[j][i].components_contained.size() != 0:
                row += "[" + str(blocks[j][i].components_contained[0][1]) + "]"
            else:
                row += "[" + str(0) + "]"
        print(row)
    print("=================================================")


func setup_test_scenario():
    setup(3, 3)
    add(Threadmill.new(), Vector2(0,0), Vector2(1,0), Vector2(0,1))
    add(Threadmill.new(), Vector2(0,1), Vector2(0,-1), Vector2(0,1))
    add(Threadmill.new(), Vector2(0,2), Vector2(0,-1), Vector2(1,0))
    add(Threadmill.new(), Vector2(1,2), Vector2(-1,0), Vector2(1,0))
    add(Threadmill.new(), Vector2(2,2), Vector2(-1,0), Vector2(0,-1))
    add(Threadmill.new(), Vector2(2,1), Vector2(0,1), Vector2(0,-1))
    add(Threadmill.new(), Vector2(2,0), Vector2(0,1), Vector2(-1,0))
    add(Threadmill.new(), Vector2(1,0), Vector2(1,0), Vector2(-1,0))
    blocks[1][0].receive([1, 0])
    blocks[1][2].receive([1, 0])


func process_test_scenario(delta):
    for i in width:
        for j in height:
            blocks[i][j].move(delta)
    print_blocks()
