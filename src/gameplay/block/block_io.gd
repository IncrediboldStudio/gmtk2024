extends Resource

class_name BlockIO

enum Direction {
  UP,
  DOWN,
  LEFT,
  RIGHT
} 

@export var pos : Vector2i
@export var edge : Direction