extends Button

class_name UpgradeFactoryButton

func _ready() -> void:
    disabled = true
    EventEngine.all_component_delivered.connect(_on_all_component_delivered)
    
func _on_pressed() -> void:
    EventEngine.upgrade_factory.emit()
    disabled = true
    
func _on_all_component_delivered() -> void:
    disabled = false
