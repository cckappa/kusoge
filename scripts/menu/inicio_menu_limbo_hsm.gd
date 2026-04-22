extends LimboHSM

@export var limbo_initial_state: LimboState

@onready var init_state:LimboState=$InitState
@onready var menu_base:LimboState=$MenuBase
@onready var menu_juego_nuevo:LimboState=$MenuJuegoNuevo
@onready var started_game:LimboState=$StartedGame
@onready var quitted_game:LimboState=$QuittedGame

@onready var black_rect := %BlackRect

const INICIAL := preload("res://scenes/maps/cueva_demo_tecnico.tscn")
const DEMO_SCENE := preload("res://scenes/maps/demo_tecnico_hub.tscn")

func _ready() -> void:
	initialize(self)
	initial_state = limbo_initial_state
	set_transitions()
	set_blackboard()
	set_active(true)

func set_transitions() -> void:
	add_transition(init_state, menu_base, "to_menu_base")
	add_transition(menu_base, started_game, "to_started_game")
	add_transition(menu_base, quitted_game, "to_quitted_game")
	add_transition(menu_base, menu_juego_nuevo, "to_menu_juego_nuevo")
	add_transition(menu_juego_nuevo, menu_base, "to_menu_base")

func set_blackboard() -> void:
	blackboard.set_var("black_rect", black_rect)
	blackboard.set_var("demo_scene", DEMO_SCENE)
	blackboard.set_var("inicial_scene", INICIAL)