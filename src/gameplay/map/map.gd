extends Node2D

enum Click_Helded {
  LEFT_CLICK,
  RIGHT_CLICK,
  NONE,
} 

@export var tile_size = Vector2i(16,16)
@export var map_size = Vector2i(8,8)
@export var selected_block_data : BlockData

var block_preview : Sprite2D

var select_tiles = Array2D.new()
var blocks : Array[Block]
var highlighted_tiles : Array[SelectTile]

var last_tile_dragged : Vector2i
var click_helded = Click_Helded.NONE

func _ready():
    block_preview = get_node("BlockPreview")
    block_preview.texture = selected_block_data.texture
    block_preview.offset = selected_block_data.texture_offset - (tile_size / 2)

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

func _process(delta: float):
    block_preview.position = get_viewport().get_mouse_position()

func _unhandled_input(event):
    if click_helded == Click_Helded.LEFT_CLICK:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
            if !event.pressed:
                print("released!")
                click_helded = Click_Helded.NONE
    elif click_helded == Click_Helded.RIGHT_CLICK:
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
            if !event.pressed:
                print("released!")
                click_helded = Click_Helded.NONE

func _handle_selectable_tile_left_clicked(selected_tile : SelectTile):
    last_tile_dragged = selected_tile.map_pos
    click_helded = Click_Helded.LEFT_CLICK

    _place_block(selected_tile)

func _handle_selectable_tile_right_clicked(selected_tile : SelectTile):
    last_tile_dragged = selected_tile.map_pos
    click_helded = Click_Helded.RIGHT_CLICK

    _remove_block(selected_tile)

func _handle_selectable_tile_hovered(selected_tile : SelectTile):
    if click_helded == Click_Helded.LEFT_CLICK:
        _place_block(selected_tile)
        print("Dragged from " + str(last_tile_dragged))
        last_tile_dragged = selected_tile.map_pos
    elif click_helded == Click_Helded.RIGHT_CLICK:
        _remove_block(selected_tile)
    else:
        _update_tile_highlight(selected_tile)

func _place_block(selected_tile : SelectTile):
    if _is_block_placable(selected_tile.map_pos):
        var block = preload("res://src/gameplay/block/block.tscn")
        var instance = block.instantiate()
        add_child(instance)
        instance.block_data = selected_block_data
        instance.position = selected_tile.map_pos * tile_size
        blocks.append(instance)

        for tile in _get_all_tiles_at_position_for_selected_block(selected_tile.map_pos):
            tile.occupied = true
            tile.placed_block = instance
            instance.used_tiles.append(tile)

    _update_tile_highlight(selected_tile)

func _remove_block(selected_tile : SelectTile):
    if selected_tile.occupied:
        var block = selected_tile.placed_block
        var used_tiles = blocks[blocks.find(block)].used_tiles
        for tile in used_tiles:
            tile.occupied = false
            tile.placed_block = null
        
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
    for block_space in selected_block_data.block_layout:
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
    for block_space in selected_block_data.block_layout:
        var block_space_map_pos = map_pos + block_space
        if block_space_map_pos.x >= 0 and block_space_map_pos.x < map_size.x:
            if block_space_map_pos.y >= 0 and block_space_map_pos.y < map_size.y:
                var select_tile = select_tiles.get_value(block_space_map_pos)
                tiles.append(select_tile)
    return tiles
