extends Node2D

class_name Map

enum Click_Held {
  LEFT_CLICK,
  RIGHT_CLICK,
  NONE,
}

@export var tile_size = Vector2i(16,16)
@export var map_size = Vector2i(8,8)

var block_preview : AnimatedSprite2D
var block_selector : BlockSelector

var select_tiles = Array2D.new()
var blocks : Array[Block]
var highlighted_tiles : Array[SelectTile]

var click_held = Click_Held.NONE

var current_frame = 0

func _ready():
    block_selector = get_node("BlockSelector")
    block_preview = get_node("BlockPreview")
    block_selector._on_selected_block_changed.connect(_on_selected_block_changed)
    _on_selected_block_changed(block_selector.get_block())

    select_tiles.resize(map_size)

    var select_tile = preload("res://src/gameplay/map/select_tile/select_tile.tscn")
    for x in map_size.x:
        for y in map_size.y:
            var instance = select_tile.instantiate()
            add_child(instance)
            instance.position = Vector2i(x,y) * tile_size
            instance.map_pos = Vector2i(x,y)
            instance.tile_left_clicked.connect(_handle_selectable_tile_left_clicked)
            instance.tile_right_clicked.connect(_handle_selectable_tile_right_clicked)
            instance.tile_hovered.connect(_handle_selectable_tile_hovered)
            select_tiles.set_value(Vector2i(x,y), instance)

func _process(_delta: float):
    block_preview.position = get_viewport().get_mouse_position()

func _unhandled_input(event):
    if click_held == Click_Held.LEFT_CLICK:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
            if !event.pressed:
                print("released!")
                block_selector.last_tile_dragged = null
                click_held = Click_Held.NONE
    elif click_held == Click_Held.RIGHT_CLICK:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
            if !event.pressed:
                print("released!")
                block_selector.last_tile_dragged = null
                click_held = Click_Held.NONE

func _handle_selectable_tile_left_clicked(selected_tile : SelectTile):
    _place_block(selected_tile)
    block_selector.last_tile_dragged = selected_tile
    click_held = Click_Held.LEFT_CLICK

func _handle_selectable_tile_right_clicked(selected_tile : SelectTile):
    _remove_block(selected_tile)
    block_selector.last_tile_dragged = selected_tile
    click_held = Click_Held.RIGHT_CLICK

func _handle_selectable_tile_hovered(selected_tile : SelectTile):
    if click_held == Click_Held.LEFT_CLICK:
        _place_block(selected_tile)
        if block_selector.is_conveyor_selected():
            block_selector.update_last_placed_tile(selected_tile)
        print("Dragged from " + str(block_selector.last_tile_dragged.map_pos))
        block_selector.last_tile_dragged = selected_tile
    elif click_held == Click_Held.RIGHT_CLICK:
        _remove_block(selected_tile)
    else:
        _update_tile_highlight(selected_tile)

func _place_block(selected_tile : SelectTile):
    if _is_block_placable(selected_tile.map_pos):
        var block_data = block_selector.get_block_for_tile(selected_tile)
        var block : PackedScene
        if block_data.block_type == BlockData.BlockType.Conveyor:
            block = preload("res://src/gameplay/block/conveyor.tscn")
        elif block_data.block_type == BlockData.BlockType.Assembler:
            block = preload("res://src/gameplay/block/assembler.tscn")
        elif block_data.block_type == BlockData.BlockType.Producer:
            block = preload("res://src/gameplay/block/producer.tscn")
        elif block_data.block_type == BlockData.BlockType.Receiver:
            block = preload("res://src/gameplay/block/receiver.tscn")
        var instance = block.instantiate()
        add_child(instance)
        instance.block_data = block_data
        instance.position = selected_tile.map_pos * tile_size
        instance.grid_pos = selected_tile.map_pos
        blocks.append(instance)

        for tile in _get_all_tiles_at_position_for_selected_block(selected_tile.map_pos):
            tile.occupied = true
            tile.placed_block = instance
            instance.used_tiles.append(tile)
    else:
        if block_selector.is_conveyor_selected():
            block_selector.verify_already_placed_block_data(selected_tile)
    

    _update_tile_highlight(selected_tile)

func _remove_block(selected_tile : SelectTile):
    if selected_tile.occupied:
        var block = selected_tile.placed_block
        var used_tiles = blocks[blocks.find(block)].used_tiles
        for tile in used_tiles:
            tile.occupied = false
            tile.placed_block = null
        
        blocks.remove_at(blocks.find(block))
        block.queue_free()
        
    _update_tile_highlight(selected_tile)

func _update_tile_highlight(selected_tile : SelectTile):
    _clear_highlights()

    #Is a tile occupied?
    var can_place_previewed_block = _is_block_placable(selected_tile.map_pos)

    for tile in _get_all_tiles_at_position_for_selected_block(selected_tile.map_pos):
        tile.show_highlight(can_place_previewed_block)
        highlighted_tiles.append(tile)

func _on_mouse_quited_area():
    _clear_highlights()
    block_preview.visible = false

func _on_mouse_entered_area():
    block_preview.visible = true

func _clear_highlights():
    for tile in highlighted_tiles:
        tile.hide_highlight()
    highlighted_tiles.clear()


#Check if all tiles are inside the map and unoccupied
func _is_block_placable(map_pos : Vector2i):
    for block_space in block_selector.get_block().block_layout:
        var block_space_map_pos = map_pos + block_space
        if block_space_map_pos.x >= 0 and block_space_map_pos.x < map_size.x:
            if block_space_map_pos.y >= 0 and block_space_map_pos.y < map_size.y:
                var select_tile = select_tiles.get_value(block_space_map_pos)
                if select_tile.occupied:
                    return false
            else:
                return false
        else:
            return false
    return true

#Only returns tiles that are inside the map
func _get_all_tiles_at_position_for_selected_block(map_pos : Vector2i):
    var tiles : Array[SelectTile]
    for block_space in block_selector.get_block().block_layout:
        var block_space_map_pos = map_pos + block_space
        if block_space_map_pos.x >= 0 and block_space_map_pos.x < map_size.x:
            if block_space_map_pos.y >= 0 and block_space_map_pos.y < map_size.y:
                var select_tile = select_tiles.get_value(block_space_map_pos)
                tiles.append(select_tile)
    return tiles

func _on_selected_block_changed(block_data : BlockData):
    block_preview.sprite_frames = block_selector.get_block().sprite_frames
    block_preview.animation = "preview"
    block_preview.offset = block_selector.get_block().texture_offset - (tile_size / 2)

func _on_anim_frame_update():
    current_frame = current_frame + 1
    for block in blocks:
        block.advance_animation(current_frame)
