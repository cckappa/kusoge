extends LimboState

func _setup() -> void:
	set_visibility(false)

func _enter() -> void:
	set_visibility(false)
	get_tree().paused = false

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("pause") and not blackboard.get_var("talking") and is_active():
		dispatch("to_base_state")

func _exit() -> void:
	set_visibility(true)
	get_tree().paused = true

func set_visibility(_visible:bool) -> void:
	blackboard.get_var("tamagotchi").visible = _visible
	agent.visible = _visible
