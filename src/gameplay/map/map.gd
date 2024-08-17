extends Node2D

@export var tile_size = Vector2i(16,16)
@export var map_size = Vector2i(8,8)
@export var selected_block_data : BlockData

var blocks = Array2D.new()
var select_tiles = Array2D.new()
var highlighted_tiles : Array[SelectTile]

var block_preview : Sprite2D

func _ready():
	block_preview = get_node("BlockPreview")
	block_preview.texture = selected_block_data.texture
	block_preview.offset = selected_block_data.texture_offset - (tile_size / 2)

	blocks.resize(map_size)
	select_tiles.resize(map_size)

	var select_tile = preload("res://src/gameplay/map/select_tile/select_tile.tscn")
	for x in map_size.x:
		for y in map_size.y:
			var instance = select_tile.instantiate()
			add_child(instance)
			instance.position = Vector2i(x,y) * tile_size
			instance.map_pos = Vector2i(x,y)
			instance.tile_clicked.connect(place_block)
			instance.tile_hovered.connect(_update_tile_highlight)
			select_tiles.set_value(Vector2i(x,y), instance)

func _process(delta: float):
	block_preview.position = get_viewport().get_mouse_position()

func place_block(block_origin : Vector2i):
	if _is_block_placable(block_origin):
		var block = preload("res://src/gameplay/block/block.tscn")
		var instance = block.instantiate()
		add_child(instance)
		instance.block_data = selected_block_data
		instance.position = block_origin * tile_size
		blocks.set_value(block_origin, instance)

		for tile in _get_all_tiles_at_position_for_selected_block(block_origin):
			tile.occupied = true
		
		_update_tile_highlight(block_origin)

func _update_tile_highlight(hover_map_pos : Vector2i):
	_clear_highlights()

	#Is a tile occupied?
	var can_place_previewed_block = _is_block_placable(hover_map_pos)

	for tile in _get_all_tiles_at_position_for_selected_block(hover_map_pos):
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
