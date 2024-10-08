extends Resource
class_name BlockData

enum BlockType{
    Conveyor,
    Producer,
    Assembler,
    Receiver
}

@export var sprite_frames : SpriteFrames
@export var texture_offset : Vector2i
@export var texture_rotation : float
@export var block_layout : Array[Vector2i]
@export var inputs : Array[BlockIO]
@export var outputs : Array[BlockIO]
@export var block_type : BlockType
@export var is_unremovable: bool
@export var component_data: ComponentData
