class_name DamageAbility
extends Ability

@export var damage_points:int

func use_ability() -> void:
	print('Damaged ', damage_points, '!')
