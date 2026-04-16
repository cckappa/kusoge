extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var party_hidden_state:=$MenuTamagotchiPartyHiddenState
@onready var party_base_state:=$MenuTamagotchiPartyBaseState

func _setup() -> void:
	_set_transitions()
	initial_state = limbo_initial_state

func _set_transitions() -> void:
	add_transition(party_hidden_state, party_base_state, "to_party_base_state")
