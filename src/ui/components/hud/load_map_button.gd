extends Node

@export var level : int

func _on_pressed() -> void:
	EventEngine.load_level.emit(level)
