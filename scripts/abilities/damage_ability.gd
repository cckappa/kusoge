class_name DamageAbility
extends Ability

@export var damage_points:int

func use_ability(character: Character, crit:bool=false) -> void:
	var total_damage := 0
	if crit:
		total_damage = ceil(damage_points * Globals.crit_multiplier)
	else:
		total_damage = damage_points
	
	for trinket in Globals.trinkets:
		if trinket is DamageMultiplierTrinket:
			total_damage = trinket.apply_effect(total_damage, self)

	print('Damaged ', total_damage, '!')
	character.reduce_health(total_damage, crit)
