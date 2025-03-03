extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	player.velocity.y = 0.0
	
	if data.is_empty():
		data["last_facing_direction"] = Vector2(0,0)
	
	animation_tree["parameters/Idle/blend_position"] = data["last_facing_direction"]
	animation_tree["parameters/conditions/idle"] = true
	SignalBus.connect("starts_talking", starts_talking_idle)
	if !SignalBus.is_connected("starts_fighting", get_caught_idle):
		SignalBus.connect("starts_fighting", get_caught_idle)
	
	if not blink_timer.timeout.is_connected(insert_blink):
		blink_timer.timeout.connect(insert_blink)
	
	blink_timer.start()
	print('entra idle')

func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		animation_tree["parameters/conditions/idle"] = false
		SignalBus.disconnect("starts_talking", starts_talking_idle)
		SignalBus.disconnect("starts_fighting", get_caught_idle)
		finished.emit(RUNNING)

func starts_talking_idle() -> void:
	SignalBus.disconnect("starts_talking", starts_talking_idle)
	SignalBus.disconnect("starts_fighting", get_caught_idle)
	finished.emit(TALKING, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})

func get_caught_idle() -> void:
	if SignalBus.is_connected("starts_talking", starts_talking_idle):
		SignalBus.disconnect("starts_talking", starts_talking_idle)
	SignalBus.disconnect("starts_fighting", get_caught_idle)
	finished.emit(CAUGHT, {"last_facing_direction": animation_tree["parameters/Idle/blend_position"]})

func insert_blink() -> void:
	var anim_name := get_idle_direction()
	
	if animation_player.has_animation(anim_name):
		var anim :Animation= animation_player.get_animation(anim_name)
		
		if anim:
			#var total_frames := anim.track_get_key_count(0)
			anim.track_insert_key(0, 0.6, 4)
			await get_tree().create_timer(0.5).timeout  # Blink lasts 0.1s
			anim.track_remove_key_at_time(0, 0.6)
			anim.track_insert_key(0, 0.6, 3)
			
	blink_timer.wait_time = randf_range(3, 7)
	blink_timer.start()


func get_idle_direction() -> String:
	var blend_pos: Vector2 = animation_tree["parameters/Idle/blend_position"]
	if blend_pos.y < -0.5:
		return "idle_up"
	elif blend_pos.y > 0.5:
		return "idle_down"
	elif blend_pos.x < -0.5:
		return "idle_left"
	elif blend_pos.x > 0.5:
		return "idle_right"
	return "idle_down"  # Default idle if centered
