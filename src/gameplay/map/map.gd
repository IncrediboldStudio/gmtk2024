extends Node2D

@export var tile_size = Vector2i(16,16)
@export var map_size = Vector2i(8,8)

var tiles = Array2D.new()
var select_tiles = Array2D.new()

var block_preview : Sprite2D
@export var test_block : Block

func _ready():
	block_preview = get_node("BlockPreview")

	tiles.resize(map_size)
	select_tiles.resize(map_size)

	var tile = preload("res://src/gameplay/map/select_tile/select_tile.tscn")
	for x in map_size.x:
		for y in map_size.y:
			var instance = tile.instantiate()
			add_child(instance)
			instance.position = position + Vector2(x*tile_size.x, y*tile_size.y)
			instance.tile_pos = Vector2i(x,y)
			instance.tile_clicked.connect(place_block)
			select_tiles.set_value(Vector2i(x,y), instance)

func _process(delta: float):
	block_preview.position = get_viewport().get_mouse_position()

func place_block(block_origin : Vector2i):
	var tile = preload("res://src/gameplay/block/block.tscn")
	var instance = tile.instantiate()
	add_child(instance)
	instance.position = block_origin * tile_size
	tiles.set_value(block_origin, instance)
	select_tiles.get_value(block_origin).tile_occupied = true
