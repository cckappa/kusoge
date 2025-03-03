extends BattleStateEnemy

var used_ability: Ability 
var current_member: Character

enum resolver{
	ABILITY
}

func enter(previous_state_path: String, data := {}) -> void:
	used_ability = data.ability
	current_member = data.member
	
	
	
	select_target(current_member.selection.select(alive_allies(Globals.current_arrange_allies), alive_enemies(Globals.current_arrange_enemies), Selection.FromCharacter.ENEMY, used_ability), used_ability)
	#current_member.current_container.selected()

func select_target(target:Character, ability:Ability)->void:
	if target is Character and target.current_hp > 0:
		use_ability(target, ability)

func use_ability(target:Character, current_ability:Ability) -> void:
	if current_member.current_container.reset_timer(current_ability.wait_time):
		current_ability.use_ability(target)
		finished.emit(RESOLVING, {'current_member': current_member, 'type': resolver.ABILITY})
