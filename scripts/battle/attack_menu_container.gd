extends HBoxContainer

@onready var asterisco:=$Asterisco
@onready var habilidad_text:=$HabilidadText
@onready var selected_button:=$Button

var ability:AbilityNew

func set_info(_ability:AbilityNew) -> void:
	ability = _ability
	habilidad_text.text = _ability.ability_effect.ability_name

func _on_button_focus_entered() -> void:
	asterisco.text = "*"
	print("Focused ability: ", ability.ability_effect.ability_name)
	SignalBus.emit_signal("attack_menu_focused", ability)

func _on_button_focus_exited() -> void:
	asterisco.text = ""

func _on_button_pressed() -> void:
	SignalBus.emit_signal("attack_menu_pressed", ability)
	print("Pressed ability: ", ability.ability_effect.ability_name)
