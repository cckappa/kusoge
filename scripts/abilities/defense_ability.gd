
class_name DefenseAbility
extends Ability

@export var block_points_percent:float
var current_armor_percent:float

func use_ability(character: Character, crit:bool=false) -> void:
	print(block_points_percent)
	current_armor_percent = (100 - clamp(block_points_percent, 0, 100)) / 100
	print('Blocked ', current_armor_percent, '!')
	character.add_armor(current_armor_percent)
	current_armor_percent = 0.0

