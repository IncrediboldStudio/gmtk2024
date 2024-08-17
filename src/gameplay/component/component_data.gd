extends Resource

class_name ComponentData

enum COMPONENT_TYPE {
    Test,
    TestAssembly
}
    

@export var type: COMPONENT_TYPE
@export var texture: Texture
@export var texture_offset: Vector2i
@export var size_in_block_ratio = 20.0
