extends LimboHSM

@export var limbo_initial_state: LimboState
@export var menu_sub_viewport : SubViewportContainer

@onready var hidden_state:LimboState=$MenuTamagotchiHiddenState
@onready var base_state:LimboState=$MenuTamagotchiBaseState
@onready var party_hsm:LimboState=%MenuTamagotchiPartyLimboHSM

@onready var tamagotchi:=%Tamagotchi
@onready var party_control:Control=%PartyControl
@onready var member_description_control:Control=%MemberDescriptionControl
@onready var pov_container:PanelContainer=%PovContainer

func _ready() -> void:
	SignalBus.connect("starts_talking", starts_talking)
	SignalBus.connect("stops_talking", stops_talking)
	_set_transitions()
	_set_blackboard()
	initialize(menu_sub_viewport)
	initial_state = limbo_initial_state
	set_active(true)

func _set_transitions() -> void:
	add_transition(hidden_state, base_state, "to_base_state")
	add_transition(base_state, hidden_state, "to_hidden_state")
	add_transition(base_state, party_hsm, "to_party_hsm")

func _set_blackboard() -> void:
	blackboard.set_var("talking", false)
	blackboard.set_var("tamagotchi", tamagotchi)
	blackboard.set_var("party_control", party_control)
	blackboard.set_var("member_description_control", member_description_control)
	blackboard.set_var("pov_container", pov_container)

func starts_talking() -> void:
	blackboard.set_var("talking", true)

func stops_talking() -> void:
	blackboard.set_var("talking", false)
