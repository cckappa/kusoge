extends BattleState

var used_ability: Ability 
var current_member: Character

enum resolver{
	ABILITY,
	BACK
}

func enter(previous_state_path: String, data := {}) -> void:
	used_ability = data.ability
	current_member = data.member
	current_member.current_container.selected()

func handle_input(event:InputEvent) -> void:
	if event.is_action_pressed("left"):
		select_target("left", used_ability)
	elif event.is_action_pressed("up"):
		select_target("up", used_ability)
	elif event.is_action_pressed("down"):
		select_target("down", used_ability)
	elif event.is_action_pressed("right"):
		select_target("right", used_ability)
	elif event.is_action_pressed("joypad_1"):
		select_target("joypad_1", used_ability)
	elif event.is_action_pressed("joypad_2"):
		select_target("joypad_2", used_ability)
	elif event.is_action_pressed("joypad_3"):
		select_target("joypad_3", used_ability)
	elif event.is_action_pressed("joypad_4"):
		select_target("joypad_4", used_ability)
	elif event.is_action_pressed("back"):
		finished.emit(RESOLVING, {'current_member': current_member, 'type': resolver.BACK})
	else:
		pass


func select_target(target:String, ability:Ability)->void:
	if Globals.current_arrange[target] is Character and Globals.current_arrange[target].current_hp > 0:
		use_ability(Globals.current_arrange[target], ability)

func use_ability(target:Character, current_ability:Ability) -> void:
#	PASAR FUNCION A RESOLVING
	if current_member.current_container.reset_timer(current_ability.wait_time):
		if current_member.current_hp <= 0:
			finished.emit(RESOLVING, {'current_member': current_member, 'type': resolver.BACK})
		else:
			current_ability.use_ability(target)
			finished.emit(RESOLVING, {'current_member': current_member, 'type': resolver.ABILITY})
		
