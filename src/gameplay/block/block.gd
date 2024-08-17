extends Node

class_name Block

var next_block: Block
var components_contained = 0
var received_now = false


func send():
    print("send shouldn't be called here")


func receive(components) -> bool:
    print("receive shouldn't be called here")
    return false
