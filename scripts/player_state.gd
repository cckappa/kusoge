class_name PlayerState
extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"

var player:PlayableCharacter

@export var animation_tree:AnimationTree

func _ready() -> void:
	await owner.ready
	player = owner as PlayableCharacter
