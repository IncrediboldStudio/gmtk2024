extends Node2D

class_name Block

var previous_block: Block
var next_block: Block
var exit_direction: Vector2
@export var distance_to_adjacent: float

# Contains [Component, progression in %]
var components_contained = []


func move(_delta):
    print("send shouldn't be called here")


func receive(_components):
    print("receive shouldn't be called here")
    

func try_set_previous_block(new_block: Block):
    if (new_block.next_block == null || new_block.next_block.get_class() == "Block"):
        previous_block = new_block
        new_block.next_block = self
        distance_to_adjacent = (position - new_block.position).length()
    

func try_set_next_block(new_block: Block):
    if (new_block.previous_block == null || new_block.previous_block.get_class() == "Block"):
        next_block = new_block
        new_block.previous_block = self
