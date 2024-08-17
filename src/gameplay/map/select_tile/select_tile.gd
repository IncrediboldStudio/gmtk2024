extends Node2D

var tile_pos : Vector2i
var tile_occupied: set = _set_tile_occupied
var tile_highlighted = false

var highlight_valid : Sprite2D
var highlight_invalid : Sprite2D

signal tile_clicked(tile_pos : Vector2i)

func _ready():
    highlight_valid = get_node("HighlightValid")
    highlight_invalid = get_node("HighlightInvalid")

func _on_tile_hovered():
    tile_highlighted = true
    if tile_occupied:
        highlight_invalid.visible = true
    else:
        highlight_valid.visible = true

func _on_stop_tile_hovered():
    tile_highlighted = false
    highlight_valid.visible = false
    highlight_invalid.visible = false

func _on_tile_clicked(viewport: Node, event: InputEvent, shape_idx: int):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            print("clicked! " + str(tile_pos))
            tile_clicked.emit(tile_pos)

func _set_tile_occupied(value):
    tile_occupied = value
    if tile_highlighted:
        if tile_occupied:
            highlight_valid.visible = false
            highlight_invalid.visible = true
        else:
            highlight_valid.visible = true
            highlight_invalid.visible = false
        
        