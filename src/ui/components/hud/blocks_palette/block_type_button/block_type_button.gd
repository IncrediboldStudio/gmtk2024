extends Control

@export var block_data : BlockData

func _ready():
    var text_rect = get_node("MarginContainer/TextureRect")
    text_rect.sprite_frames = block_data.sprite_frames
    text_rect.animation = "preview"

func _on_block_selected():
    EventEngine.change_selected_block.emit(block_data)
    SfxManager.play_sfx(SfxManager.SfxName.UI_POP_3, SfxManager.SfxVariation.MEDIUM)
