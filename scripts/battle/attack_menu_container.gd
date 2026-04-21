extends HBoxContainer

@onready var asterisco:=$Asterisco
@onready var habilidad_text:=$HabilidadText
@onready var selected_button:=$Button

var ability:Ability

func set_info(_ability:Ability) -> void:
	ability = _ability
	habilidad_text.text = _ability.ability_name

func _on_button_focus_entered() -> void:
	asterisco.text = "*"
	SignalBus.emit_signal("attack_menu_focused", ability)

func _on_button_focus_exited() -> void:
	asterisco.text = ""

func _on_button_pressed() -> void:
	print(ability.ability_name)
