@tool
extends ResourceVariant

@export var name : String :
    set(value):
        name = value
        changed.emit()

@export var weight : int :
    set(value):
        weight = value
        changed.emit()