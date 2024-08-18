extends Node2D

class_name Block

var sprite : Sprite2D

var block_data : BlockData : set = _set_block_data

var used_tiles : Array[SelectTile]

var sub_block: Block
var previous_block: Block
var next_block: Block
var exit_direction: Vector2
@export var distance_to_adjacent: float

# Contains [Component, progression in %]
var components_contained = []

func _ready():
	sprite = get_node("Sprite2D")

func move(_delta):
	return


func receive(_components):
	return
	

func try_set_previous_block(new_block: Block):
	if (new_block.next_block == null || new_block.next_block.get_class() == "Block"):
		previous_block = new_block
		new_block.next_block = self
		distance_to_adjacent = (position - new_block.position).length()
	

func try_set_next_block(new_block: Block):
	if (new_block.previous_block == null || new_block.previous_block.get_class() == "Block"):
		next_block = new_block
		new_block.previous_block = self

func _set_block_data(value):
	block_data = value
	sprite.texture = block_data.texture
	sprite.position = block_data.texture_offset
	sprite.rotation = deg_to_rad(block_data.texture_rotation)
