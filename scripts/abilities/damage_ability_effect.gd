class_name DamageAbilityEffect
extends AbilityEffect

@export var damage_amount: int = 0
@export var wait_time:=1.0
@export var attack_animation:PackedScene

func use_ability(character:Character, container:Node, crit:bool=false) -> void:
	var total_damage := 0
	if crit:
		total_damage = ceil(damage_amount * Globals.crit_multiplier)
	else:
		total_damage = damage_amount
	
	print('Damaged ', total_damage, '!')
	character.reduce_health(total_damage, crit)
	if character.disabled:
		container.kill_character()

	container.set_health()
	container.show_damage(total_damage)
	container.show_attacked()
