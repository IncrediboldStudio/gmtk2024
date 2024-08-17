extends Node

class_name Block

var next_block: Block

# Contains [Component, progression in %]
var components_contained = []


func move(_delta):
    print("send shouldn't be called here")


func receive(_components):
    print("receive shouldn't be called here")
