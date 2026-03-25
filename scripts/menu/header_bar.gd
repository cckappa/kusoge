extends HBoxContainer

@export var title_text : String
@onready var title := %Title

func _ready() -> void:
	title.text = title_text