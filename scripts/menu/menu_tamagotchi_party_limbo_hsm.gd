extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var party_hidden_state:=$MenuTamagotchiPartyHiddenState
@onready var party_base_state:=$MenuTamagotchiPartyBaseState
@onready var party_party_option_state:=$MenuTamagotchiPartyOptionState
@onready var party_member_option_state:=$MenuTamagotchiMemberOptionState

func _setup() -> void:
	_set_transitions()
	initial_state = limbo_initial_state

func _enter() -> void:
	pass

func _set_transitions() -> void:
	add_transition(party_hidden_state, party_base_state, "to_party_base_state")
	add_transition(party_base_state, party_hidden_state, "to_party_hidden_state")
	add_transition(party_base_state, party_party_option_state, "to_party_party_option_state")
	add_transition(party_base_state, party_member_option_state, "to_party_member_option_state")
	add_transition(party_party_option_state, party_base_state, "to_party_base_state")
	add_transition(party_party_option_state, party_hidden_state, "to_party_hidden_state")
	add_transition(party_member_option_state, party_base_state, "to_party_base_state")
	add_transition(party_member_option_state, party_hidden_state, "to_party_hidden_state")

