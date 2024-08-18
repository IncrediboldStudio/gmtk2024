extends Control

var palette : Control

func _ready():
	palette = get_node("ScrollContainer/MarginContainer/VBoxContainer")
	EventEngine.change_level.connect(_on_change_level)

func _on_change_level(level : Level):
	set_palette_data(level.block_palette)

func set_palette_data(new_palette_data : Array[BlockData]):
	var current_palette = palette.get_children()
	for block_type_button in current_palette:
		block_type_button.queue_free()
	
	for block_data in new_palette_data:
		var block_type_button = preload("res://src/ui/components/hud/blocks_palette/block_type_button/block_type_button.tscn")
		var instance = block_type_button.instantiate()
		palette.add_child(instance)
		instance.block_data = block_data
