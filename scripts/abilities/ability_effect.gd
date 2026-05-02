@abstract
class_name AbilityEffect
extends Resource

@export var identifier:String

var ability_name:String:
	get:
		return tr("abilities/%s/name" % identifier)
var description:String:
	get:
		return tr("abilities/%s/description" % identifier)


@abstract
func use_ability(character:Character, container:Node,crit:bool=false) -> void
