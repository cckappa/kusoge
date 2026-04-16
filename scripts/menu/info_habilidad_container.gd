extends VBoxContainer

@onready var habilidad_text:=$HabilidadText
@onready var info_habilidad_text:=$InfoHabilidadText


func set_info(_habilidad_text:String, _info_habilidad_text:String) -> void:
	habilidad_text.text = _habilidad_text
	info_habilidad_text.text = _info_habilidad_text