extends Node

class_name factory

var height
var width
var blocks = []

func setup(new_width, new_height):
    width = new_width
    height = new_height
    for i in width:
        blocks.append([])
        blocks[i].resize(height)
        blocks[i].fill(Block.new())


func add(new_block: Block, position: Vector2, entry: Vector2, exit: Vector2):
    blocks[position.x][position.y].queue_free()
    blocks[position.x][position.y] = new_block
    
    var adjacent_block_position = position - entry
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        blocks[adjacent_block_position.x][adjacent_block_position.y].next_block = new_block
    
    adjacent_block_position = position + exit
    if (adjacent_block_position.x >= 0 && adjacent_block_position.x < width &&
        adjacent_block_position.y >= 0 && adjacent_block_position.y < height):
        new_block.next_block = blocks[adjacent_block_position.x][adjacent_block_position.y]
        
        
