extends Node2D

class_name Block

var sprite : Sprite2D

var block_data : BlockData : set = _set_block_data
var next_block: Block

# Contains [Component, progression in %]
var components_contained = []

func _ready():
	sprite = get_node("Sprite2D")

func move(_delta):
	print("send shouldn't be called here")


func receive(_components):
	print("receive shouldn't be called here")

func _set_block_data(value):
	block_data = value
	sprite.texture = block_data.texture
	sprite.offset = block_data.texture_offset
