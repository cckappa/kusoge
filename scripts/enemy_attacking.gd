extends BattleStateEnemy

@onready var character_portraits := %AllyPortraits

var time_elapsed := 0.0
var check_interval := 1.0  # Check every 1 second


func enter(previous_state_path: String, data := {}) -> void:
	pass

func update(_delta:float) -> void:
	time_elapsed += _delta
	if time_elapsed >= check_interval:
		time_elapsed = 0.0  # Reset timer
		if alive_enemies(Globals.current_arrange_enemies).size() > 0:
			var enemy : Character = alive_enemies(Globals.current_arrange_enemies).pick_random()
			check_available_attacks(enemy)

func check_available_attacks(enemy: Character) -> void:
	if enemy != null:
		print("Checking enemy -> ", enemy.name)
		if enemy.current_container.check_timer():
			use_ability(enemy)

func use_ability(member:Character) -> void:
	if member is Character and member.current_hp > 0:
		var current_ability : Ability = member.current_abilities[1]
		finished.emit(SELECTING, {'ability': current_ability, 'member': member})
		
