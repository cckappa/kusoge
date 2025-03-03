extends BattleState

@onready var character_portraits := %AllyPortraits

func enter(previous_state_path: String, data := {}) -> void:
	pass

func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("left"):
		use_ability(Globals.current_arrange.left)
	elif event.is_action_pressed("up"):
		use_ability(Globals.current_arrange.up)
	elif event.is_action_pressed("down"):
		use_ability(Globals.current_arrange.down)
	elif event.is_action_pressed("right"):
		use_ability(Globals.current_arrange.right)
	else:
		pass

func use_ability(member:Character) -> void:
	if member is Character and member.current_hp > 0:
		var current_ability : Ability = member.current_abilities[1]
		finished.emit(SELECTING, {'ability': current_ability, 'member': member})
	
