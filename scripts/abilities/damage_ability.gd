class_name DamageAbility
extends Ability

@export var damage_points:int

func use_ability(character: Character, crit:bool=false) -> void:
	var total_damage := 0
	if crit:
		total_damage = ceil(damage_points * Globals.crit_multiplier)
	else:
		total_damage = damage_points
	print('Damaged ', total_damage, '!')
	character.reduce_health(total_damage, crit)

	# if attack_animation != null:
	# 	var anim_scene := load(attack_animation)  # Load the scene dynamically
	# 	if anim_scene is PackedScene:
	# 		var animation_instance :Node2D= anim_scene.instantiate()
	# 		add_child(animation_instance)  # Add it to the scene
		
		
