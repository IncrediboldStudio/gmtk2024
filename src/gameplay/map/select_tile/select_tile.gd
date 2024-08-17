extends Node2D

class_name SelectTile

signal tile_hovered(selected_tile : SelectTile)
signal tile_left_clicked(selected_tile : SelectTile)
signal tile_right_clicked(selected_tile : SelectTile)

var highlight_valid : Sprite2D
var highlight_invalid : Sprite2D

var map_pos : Vector2i
var placed_block : Block
var occupied = false

func _ready():
    highlight_valid = get_node("HighlightValid")
    highlight_invalid = get_node("HighlightInvalid")

func _on_tile_hovered():
    tile_hovered.emit(self)

func _on_tile_clicked(viewport: Node, event: InputEvent, shape_idx: int):
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            print("left clicked! " + str(map_pos))
            tile_left_clicked.emit(self)
        elif event.button_index == MOUSE_BUTTON_RIGHT:
            print("right clicked! " + str(map_pos))
            tile_right_clicked.emit(self)

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

        
        