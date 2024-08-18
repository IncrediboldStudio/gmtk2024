extends Node2D

class_name Block

var sprite : AnimatedSprite2D

var block_data : BlockData : set = _set_block_data

var used_tiles : Array[SelectTile]

var grid_pos: Vector2i
var previous_block: Block
var next_block: Block
var exit_direction: Vector2
const distance_to_adjacent = 64.0

# Contains [Component, progression in %]
var components_contained = []

func _ready():
    sprite = get_node("AnimatedSprite2D")

func work(_delta):
    return

func receive(_components):
    return

func clean():
    components_contained.clear()
    previous_block = null
    next_block = null

func _set_block_data(value):
    block_data = value
    sprite.sprite_frames = block_data.sprite_frames
    sprite.animation = "block"
    sprite.position = block_data.texture_offset
    sprite.rotation = deg_to_rad(block_data.texture_rotation)

func advance_animation(frame : int):
    var nb_frame = sprite.sprite_frames.get_frame_count("block")
    var new_frame = frame % nb_frame
    sprite.frame = new_frame
