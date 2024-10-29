extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if data.is_empty():
		data["last_facing_direction"] = Vector2(0,0)
	
	last_facing_direction = data["last_facing_direction"]
	SignalBus.connect("starts_talking", starts_talking_dash)
	dashea()
	print('entra dashing')

func dashea() -> void:
	await get_tree().create_timer(player.character_info.dash_distance).timeout
	if SignalBus.is_connected("starts_talking", starts_talking_dash):
		SignalBus.disconnect("starts_talking", starts_talking_dash)
		finished.emit(RUNNING)

func physics_update(_delta: float) -> void:
	if can_dash:
		player.velocity = last_facing_direction * player.character_info.run_speed * player.character_info.dash_speed
		player.move_and_slide()
 
func starts_talking_dash() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_dash):
		SignalBus.disconnect("starts_talking", starts_talking_dash)
	finished.emit(TALKING, {"last_facing_direction": last_facing_direction})
