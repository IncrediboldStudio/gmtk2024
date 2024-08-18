extends Node

func _on_pressed() -> void:
	EventEngine.run_simulation.emit()
