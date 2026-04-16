extends Control

@onready var info_name:=%InfoName
@onready var info_texture:=%InfoTexture
@onready var info_descripcion_text:=%InfoDescripcionText

func _ready() -> void:
	SignalBus.connect("menu_party_character_focus_entered", _on_menu_party_character_focus_entered)

func _on_menu_party_character_focus_entered(_character:Character) -> void:
	info_name.text = _character.name
	info_texture.texture = _character.character_portrait
	info_descripcion_text.text = _character.description
