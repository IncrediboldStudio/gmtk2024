extends Node

@export var level : Level

func _on_pressed() -> void:
	EventEngine.change_level.emit(level)
