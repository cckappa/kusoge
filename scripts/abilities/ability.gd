class_name Ability
extends Resource

@export var ability_name:String
@export_enum(
	"NORMAL", 
	"FIRE", 
	"WATER", 
	"ELECTRIC", 
	"EARTH", 
	"ICE", 
	"WIND", 
	"GRASS") var type: String = "NORMAL"
@export var description:String
@export var wait_time: float = 1.0
@export_enum(
	"NEGATIVE",
	"POSITIVE"
) var effect: String = "NEGATIVE"

@export var attack_animation:PackedScene

func use_ability(character: Character, crit:bool=false) -> void:
	pass
