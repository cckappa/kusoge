extends Control

@onready var info_name:=%InfoName
@onready var info_texture:=%InfoTexture
@onready var info_descripcion_text:=%InfoDescripcionText
@onready var info_vida_text:=%InfoVidaText
@onready var vida_progress_bar:=%VidaProgressBar
@onready var info_habilidades_v_box:=%InfoHabilidadesVBox

var info_habilidad := load("res://scenes/menu/info_habilidad_container.tscn")

func _ready() -> void:	
	SignalBus.connect("menu_party_character_focus_entered", _on_menu_party_character_focus_entered)

func _on_menu_party_character_focus_entered(_character:Character) -> void:
	if _character.unlocked:
		info_name.text = _character.name
		info_texture.texture = _character.character_portrait
		info_texture.modulate = Color(1,1,1,1)
		info_descripcion_text.text = _character.description
		info_vida_text.text = "[center]{vida}".format({"vida":_character.current_hp})
		vida_progress_bar.value = int((float(_character.current_hp) / float(_character.max_hp)) * 100)
	else:
		info_name.text = "?????????"
		info_texture.texture = _character.character_portrait
		info_texture.modulate = Color(0,0,0,1)
		info_descripcion_text.text = "???????????"
		info_vida_text.text = "[center]{vida}".format({"vida":"???"})
		vida_progress_bar.value = 0

	
	for child in info_habilidades_v_box.get_children():
		child.queue_free()

	for ability in _character.abilities:
		var info_habilidad_instance:VBoxContainer=info_habilidad.instantiate()
		if ability.effect == "NEGATIVE":
			info_habilidades_v_box.add_child(info_habilidad_instance)
			if _character.unlocked:
				info_habilidad_instance.set_info(ability.ability_name, "_.-` d({d}) x {s}s '-._".format({"d":ability.damage_points,"s":ability.base_wait_time}))
			else:
				info_habilidad_instance.set_info("?????????", "_.-` d({d}) x {s}s '-._".format({"d":"?","s":"?"}))
		elif ability.effect == "POSITIVE":
			info_habilidades_v_box.add_child(info_habilidad_instance)
			if _character.unlocked:
				info_habilidad_instance.set_info(ability.ability_name, "_.-` h({d}) x {s}s '-._".format({"d":ability.heal_points,"s":ability.base_wait_time}))
			else:
				info_habilidad_instance.set_info("?????????", "_.-` h({d}) x {s}s '-._".format({"d":"?","s":"?"}))
