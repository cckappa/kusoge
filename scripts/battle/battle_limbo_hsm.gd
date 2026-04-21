extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var initialize_party:=$InitializeParty
@onready var focus_party:=$FocusParty
@onready var focus_attack:=$FocusAttackMenu

func _ready() -> void:
	_set_transitions()
	_set_blackboard()
	# initialize puede llevar self o un nodo parent para jalarlo con agent. dentro de limbostates
	initialize(self)
	initial_state = limbo_initial_state
	set_active(true)

func _set_transitions() -> void:
	add_transition(initialize_party, focus_party, "to_focus_party")
	add_transition(focus_attack, focus_party, "to_focus_party")
	add_transition(focus_party, focus_attack, "to_focus_attack")

func _set_blackboard() -> void:
	blackboard.set_var("current_selected_character_pos", 0)

