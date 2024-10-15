class_name PlayerState
extends State

signal dash_cooldown

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const DASHING = "Dashing"

var player:PlayableCharacter
var direction := Vector2(0,0)
var last_facing_direction := Vector2(0,0)
var can_dash:= true

@export var animation_tree:AnimationTree

func _ready() -> void:
	await owner.ready
	player = owner as PlayableCharacter
	connect("dash_cooldown", timer_dash)

func timer_dash() -> void:
	await get_tree().create_timer(player.character_info.dash_cooldown).timeout
	can_dash = true
