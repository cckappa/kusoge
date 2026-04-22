extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var initialize_battle:=$InitializeBattle
@onready var initialize_party:=$InitializeParty
@onready var focus_party:=$FocusParty
@onready var focus_attack:=$FocusAttackMenu
@onready var focus_enemy:=$FocusEnemy
@onready var win_state:=$WinState

func _ready() -> void:
	_set_transitions()
	_set_blackboard()
	# initialize puede llevar self o un nodo parent para jalarlo con agent. dentro de limbostates
	initialize(self)
	initial_state = limbo_initial_state
	set_active(true)

func _set_transitions() -> void:
	add_transition(initialize_battle, focus_party, "to_focus_party")
	add_transition(focus_party, focus_attack, "to_focus_attack")
	add_transition(focus_attack, focus_party, "to_focus_party")
	add_transition(focus_attack, focus_enemy, "to_focus_enemy")
	add_transition(focus_enemy, focus_party, "to_focus_party")
	add_transition(focus_enemy, focus_attack, "to_focus_attack")
	add_transition(focus_party, win_state, "to_win_state")
	add_transition(focus_attack, win_state, "to_win_state")
	add_transition(focus_enemy, win_state, "to_win_state")

func _set_blackboard() -> void:
	blackboard.set_var("selected_party_member", null)
	blackboard.set_var("selected_party_container", null)
	blackboard.set_var("last_selected_character_texture_button", null)
	blackboard.set_var("special_battle", false)
	blackboard.set_var("crit", false)

