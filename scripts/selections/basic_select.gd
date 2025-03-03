class_name BasicSelect
extends Selection

func select(allies: Array[Character], enemies: Array[Character], from: FromCharacter, ability:Ability) -> Character:
	var selected_target: Character
	
	if from == FromCharacter.ALLY:
		selected_target = enemies.pick_random()
	elif from == FromCharacter.ENEMY:
		selected_target = allies.pick_random()
		#print(selected_target.name)
	
	return selected_target
