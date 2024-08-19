extends Node

@export var level : int

func _on_pressed() -> void:
	EventEngine.save_level.emit(level)
