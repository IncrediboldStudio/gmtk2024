extends TabContainer


func _on_tab_changed(tab: int):
    SfxManager.play_sfx(SfxManager.SfxName.UI_POP_3, SfxManager.SfxVariation.MEDIUM)
