class_name CooldownTrinket
extends Trinket

@export var cooldown_reduction: float = 0.5

func apply_effect(ability: Ability) -> float:
	if ability.type == type:
		return ability.base_wait_time - cooldown_reduction
	return ability.base_wait_time