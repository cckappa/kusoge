extends LimboState

func _setup() -> void:
	set_visibility(false)

func _enter() -> void:
	set_visibility(false)
	# get_root().dispatch("exit_nested")
	get_root().call_deferred("dispatch","to_base_state")
	# print(get_root().get_.get_previous_active_state())
	# get_root().dispatch("to_base_state")

# func _exit() -> void:
# 	set_visibility(true)

func set_visibility(_visible:bool) -> void:
	blackboard.get_var("party_control").visible = _visible
	blackboard.get_var("member_description_control").visible = _visible
