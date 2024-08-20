extends Window

func _ready():
    close_requested.connect(_close)

func _close():
    visible = false
