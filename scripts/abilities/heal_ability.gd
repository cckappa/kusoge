class_name HealAbility
extends Ability

@export var heal_points:int

func use_ability(character: Character, crit:bool=false) -> void:
	var total_heal:= 0
	if crit:
		total_heal = ceil(heal_points * Globals.crit_multiplier)
	else:
		total_heal = heal_points
	print('Healed ', total_heal, '!')
	character.increase_health(total_heal, crit)
