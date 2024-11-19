class_name BattleState
extends State

var ENTER:="Enter"
var DECIDING:="Deciding"
var FIGHTING:="Fighting"
var ATTACKING:="Attacking"
var TARGETING:="Targeting"
var RESOLVING:="Resolving"

@export var black_rect : ColorRect


func _ready() -> void:
	await owner.ready
