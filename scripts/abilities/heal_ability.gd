class_name HealAbility
extends Ability

@export var heal_points:int

func use_ability() -> void:
	print('Healed ', heal_points, '!')
