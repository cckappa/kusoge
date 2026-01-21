class_name Ability
extends Resource

@export var identifier:String
@export_enum(
	"NORMAL", 
	"FIRE", 
	"WATER", 
	"ELECTRIC", 
	"EARTH", 
	"ICE", 
	"WIND", 
	"GRASS") var type: String = "NORMAL"
@export var base_wait_time: float = 1.0
var wait_time: float:
	get:
		for trinket in Globals.trinkets:
			if trinket is CooldownTrinket:
				return trinket.apply_effect(self)
		return base_wait_time

@export_enum(
	"NEGATIVE",
	"POSITIVE"
) var effect: String = "NEGATIVE"

@export var attack_animation:PackedScene

var ability_name:String:
	get:
		return tr("abilities/%s/name" % identifier)
var description:String:
	get:
		return tr("abilities/%s/description" % identifier)

func use_ability(character: Character, crit:bool=false) -> void:
	pass
