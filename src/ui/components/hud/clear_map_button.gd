extends Node

func _on_pressed() -> void:
	EventEngine.clear_level.emit()
