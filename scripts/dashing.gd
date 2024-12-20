extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	
	if data.is_empty():
		data["last_facing_direction"] = Vector2(0,0)
	
	last_facing_direction = data["last_facing_direction"]
	animation_tree["parameters/conditions/dash"] = true
	SignalBus.connect("starts_talking", starts_talking_dash)
	if !SignalBus.is_connected("starts_fighting", get_caught_dashing):
		SignalBus.connect("starts_fighting", get_caught_dashing)
	dashea()
	print('entra dashing')

func dashea() -> void:
	await get_tree().create_timer(player.character_info.dash_distance).timeout
	if SignalBus.is_connected("starts_fighting", get_caught_dashing):
		SignalBus.disconnect("starts_fighting", get_caught_dashing)
	if SignalBus.is_connected("starts_talking", starts_talking_dash):
		SignalBus.disconnect("starts_talking", starts_talking_dash)
		animation_tree["parameters/conditions/dash"] = false
		finished.emit(RUNNING)

func physics_update(_delta: float) -> void:
	if can_dash:
		player.velocity = last_facing_direction * player.character_info.run_speed * player.character_info.dash_speed
		player.move_and_slide()
 
func starts_talking_dash() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_dash):
		SignalBus.disconnect("starts_talking", starts_talking_dash)
	SignalBus.disconnect("starts_fighting", get_caught_dashing)
	animation_tree["parameters/conditions/dash"] = false
	finished.emit(TALKING, {"last_facing_direction": last_facing_direction})

func get_caught_dashing() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_dash):
		SignalBus.disconnect("starts_talking", starts_talking_dash)
	SignalBus.disconnect("starts_fighting", get_caught_dashing)
	animation_tree["parameters/conditions/dash"] = false
	finished.emit(CAUGHT, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})
