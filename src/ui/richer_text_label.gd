extends RichTextLabel

func _ready():
    if OS.get_name() != "HTML5":
        meta_clicked.connect(_on_rich_text_label_meta_clicked)

func _on_rich_text_label_meta_clicked(meta):
    OS.shell_open(meta)
