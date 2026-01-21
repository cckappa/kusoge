class_name DamageMultiplierTrinket
extends Trinket

@export var damage_multiplier: float = 1.0

func apply_effect(damage_value: int, ability: Ability) -> int:
	if ability.type == type:
		return int(damage_value * damage_multiplier)
	return damage_value