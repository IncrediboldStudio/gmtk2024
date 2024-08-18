extends Control

@export var block_data : BlockData

func _on_block_selected():
    EventEngine.change_selected_block.emit(block_data)
