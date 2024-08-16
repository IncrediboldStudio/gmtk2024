extends Node

class_name Block

var components_contained
var next_block: Block


func send():
    print("send shouldn't be called here")


func receive(components) -> bool:
    print("receive shouldn't be called here")
    return false
