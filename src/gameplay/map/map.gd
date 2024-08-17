extends Node2D

@export var tile_size = Vector2i(16,16)
@export var map_size = Vector2i(8,8)

@export var tile_template : PackedScene

var tiles = Array2D.new()

func _ready():
	tiles.resize(map_size)

	var tile = load(tile_template.resource_path)
	for x in map_size.x:
		for y in map_size.y:
			var instance = tile.instantiate()
			add_child(instance)
			instance.position = position + Vector2(x*tile_size.x, y*tile_size.y)
			tiles.set_value(Vector2i(x,y), instance)

