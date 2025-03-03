class_name PlayerState
extends State

signal dash_cooldown

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const DASHING = "Dashing"
const TALKING = "Talking"
const CAUGHT = "Caught"

var player:PlayableCharacter
var direction := Vector2(0,0)
var last_facing_direction : Vector2
var can_dash:= false

@export var animation_tree:AnimationTree

@onready var animation_player := %AnimationPlayer
@onready var blink_timer := Timer.new() 

func _ready() -> void:
	await owner.ready
	player = owner as PlayableCharacter
	connect("dash_cooldown", timer_dash)
	blink_timer.wait_time = randf_range(3, 7)  # Random time between blinks
	blink_timer.one_shot = true
	add_child(blink_timer)

func timer_dash() -> void:
	await get_tree().create_timer(player.character_info.dash_cooldown).timeout
	can_dash = true
