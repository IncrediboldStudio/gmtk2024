extends Node

class_name BlockSelector

@export var currently_selected_block : BlockData

@export var conveyor_data_variants : Array[BlockData]
@export var conveyor_block_base_data : BlockData

var last_tile_dragged : SelectTile

func _rotate_block(block : BlockData):
    pass

func get_block():
    return currently_selected_block

func get_block_for_tile(selected_tile : SelectTile):
    if currently_selected_block == conveyor_block_base_data:
        if last_tile_dragged and last_tile_dragged.placed_block:
            var input_direction = _get_direction_between_tiles(last_tile_dragged, selected_tile)
            var output_direction = input_direction
            if input_direction != null and output_direction != null:
                return _get_conveyor_block_data_variant(input_direction, output_direction,last_tile_dragged.placed_block.block_data)
        return conveyor_block_base_data
    return get_block()

func update_last_placed_tile(selected_tile :  SelectTile):
    if last_tile_dragged.placed_block and _is_conveyor_belt(last_tile_dragged.placed_block.block_data):
        var input_direction = last_tile_dragged.placed_block.block_data.inputs[0].edge
        var output_direction = _get_direction_between_tiles(last_tile_dragged, selected_tile)
        if input_direction != null and output_direction != null:
            last_tile_dragged.placed_block.block_data = _get_conveyor_block_data_variant(input_direction, output_direction, selected_tile.placed_block.block_data)

func verify_already_placed_block_data(selected_tile :  SelectTile):
    if last_tile_dragged:
        if _is_conveyor_belt(selected_tile.placed_block.block_data):
            var input_direction = _get_direction_between_tiles(last_tile_dragged, selected_tile)
            var output_direction = input_direction
            if input_direction != null and output_direction != null:
                selected_tile.placed_block.block_data = _get_conveyor_block_data_variant(input_direction, output_direction, last_tile_dragged.placed_block.block_data)
        
func _get_conveyor_block_data_variant(input : BlockIO.Direction, output : BlockIO.Direction, backupData : BlockData):
    for conveyor_data in conveyor_data_variants:
        if conveyor_data.inputs[0].edge == input:
            if conveyor_data.outputs[0].edge == output:
                return conveyor_data
    return backupData

func _get_direction_between_tiles(originTile : SelectTile, destinationTile : SelectTile):
    var posDiff = destinationTile.map_pos - originTile.map_pos
    if posDiff == Vector2i(1,0):
        return BlockIO.Direction.RIGHT
    if posDiff == Vector2i(-1,0):
        return BlockIO.Direction.LEFT
    elif posDiff == Vector2i(0,1):
        return BlockIO.Direction.DOWN
    elif posDiff == Vector2i(0,-1):
        return BlockIO.Direction.UP
    else:
        return null

func _is_conveyor_belt(block_data : BlockData):
    for conveyor_data in conveyor_data_variants:
        if block_data == conveyor_data:
            return true
    return false
