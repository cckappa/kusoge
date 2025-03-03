class_name HealEffectItem
extends ItemEffect

@export var heal_amount: int = 50  # Set heal amount per item

func apply_effect(targets: Array = []) -> void:
	for target:Character in targets:
		if target.has_method("increase_health"):  # Ensure target has a heal method
			target.increase_health(heal_amount)
	
