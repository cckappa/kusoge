extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if data.is_empty():
		data["last_facing_direction"] = Vector2(0,0)
	
	last_facing_direction = data["last_facing_direction"]
	dashea()
	print('entra dashing')

func dashea() -> void:
	await get_tree().create_timer(0.1).timeout
	finished.emit(RUNNING)

func physics_update(_delta: float) -> void:
	player.velocity = last_facing_direction * player.character_info.run_speed * player.character_info.dash_speed
	player.move_and_slide()
