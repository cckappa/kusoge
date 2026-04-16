extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var party_hidden_state:=$MenuTamagotchiPartyHiddenState
@onready var party_base_state:=$MenuTamagotchiPartyBaseState

func _setup() -> void:
	_set_transitions()
	initial_state = limbo_initial_state

func _enter() -> void:
	pass
	# print(get_previous_active_state())
	# if get_previous_active_state() == "me":
		
	# else:
	# 	pass

func _set_transitions() -> void:
	add_transition(party_hidden_state, party_base_state, "to_party_base_state")
	add_transition(party_base_state, party_hidden_state, "to_party_hidden_state")
	# add_transition(party_hidden_state, base_state, "to_base_state")

