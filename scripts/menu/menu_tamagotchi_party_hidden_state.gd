extends LimboState

func _setup() -> void:
	set_visibility(false)

func _enter() -> void:
	set_visibility(false)

func _exit() -> void:
	set_visibility(true)

func set_visibility(_visible:bool) -> void:
	blackboard.get_var("party_control").visible = _visible
	blackboard.get_var("member_description_control").visible = _visible
