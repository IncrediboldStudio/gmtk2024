extends Node2D

class_name SelectTile

signal tile_hovered(tile_pos : Vector2i)
signal tile_clicked(tile_pos : Vector2i)

var highlight_valid : Sprite2D
var highlight_invalid : Sprite2D

var map_pos : Vector2i
var occupied = false

func _ready():
    highlight_valid = get_node("HighlightValid")
    highlight_invalid = get_node("HighlightInvalid")

func _on_tile_hovered():
    tile_hovered.emit(map_pos)

func _on_tile_clicked(viewport: Node, event: InputEvent, shape_idx: int):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            print("clicked! " + str(map_pos))
            tile_clicked.emit(map_pos)

func hide_highlight():
    highlight_valid.visible = false
    highlight_invalid.visible = false

func show_highlight(valid_placement):
    if valid_placement:
        highlight_valid.visible = true
        highlight_invalid.visible = false
    else:
        highlight_valid.visible = false
        highlight_invalid.visible = true

        
        