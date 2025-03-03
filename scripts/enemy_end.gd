extends BattleStateEnemy

func enter(previous_state_path: String, data := {}) -> void:
	if data.end == 'win':
		print('WIN!!')
	elif data.end == 'lose':
		print('LOSE')
