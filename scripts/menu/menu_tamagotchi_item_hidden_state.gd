extends LimboState

func _setup() -> void:
	set_visibility(false)

func _enter() -> void:
	var cargo:String = get_cargo()
	set_visibility(false)

	if cargo == "pause":
		get_root().call_deferred("dispatch","to_hidden_state")
	elif cargo == "back":
		get_root().call_deferred("dispatch","to_base_state")

func set_visibility(_visible:bool) -> void:
	blackboard.get_var("items_control").visible = _visible
	blackboard.get_var("item_descriptions_control").visible = _visible
