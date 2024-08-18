extends Node2D

class_name Block

var sprite : Sprite2D

var block_data : BlockData : set = _set_block_data

var used_tiles : Array[SelectTile]

var previous_block: Block
var next_block: Block
var exit_direction: Vector2
@export var distance_to_adjacent: float

# Contains [Component, progression in %]
var components_contained = []

func _ready():
    sprite = get_node("Sprite2D")

func work(_delta):
    return

func receive(_components):
    return

func _set_block_data(value):
    block_data = value
    sprite.texture = block_data.texture
    sprite.position = block_data.texture_offset
    sprite.rotation = deg_to_rad(block_data.texture_rotation)
