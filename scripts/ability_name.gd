extends PanelContainer

@onready var ability_name:= %AbilityName
@onready var ability_button:= %AbilityButton

var ability:Ability

func set_ability_info(_ability: Ability) -> void:
	ability = _ability
	ability_name.text = ability.ability_name

func _on_ability_button_focus_entered() -> void:
	SignalBus.emit_signal("ability_name_focus_entered", ability)
	ability_name.text = "[wave amp=20 freq=5 connected=1]%s" % ability.ability_name

func _on_ability_button_focus_exited() -> void:
	ability_name.text = ability.ability_name

