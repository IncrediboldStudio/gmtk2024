extends Window

func _ready():
    close_requested.connect(_close)
    EventEngine.you_win.connect(_show)
    visible = false

func _close():
    visible = false

func _show():
    visible = true
