extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var item_hidden_state:=$MenuTamagotchiItemHiddenState
@onready var item_base_state:=$MenuTamagotchiItemBaseState

func _setup() -> void:
	_set_transitions()
	initial_state = limbo_initial_state

func _set_transitions() -> void:
	add_transition(item_base_state, item_hidden_state, "to_item_hidden_state")
	add_transition(item_hidden_state, item_base_state, "to_item_base_state")


