class_name Tile
extends Node2D

#For testing purpose
@export var test_tile : TileType

var sprite : Sprite2D

var tile_type : TileType

func _ready():
	sprite = get_node("Sprite2D")

func set_tile_type(new_tile_type : TileType):
	tile_type = new_tile_type
	sprite.texture = tile_type.texture

func _on_tile_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed:
			set_tile_type(test_tile)
