extends LimboHSM

@export var limbo_initial_state: LimboState

func _ready() -> void:
	initialize(self)
	initial_state = limbo_initial_state
	set_active(true)