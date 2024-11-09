class_name Ability
extends Resource

@export var ability_name:String
@export var sequence:Array[StringName]
@export var description:String
@export_enum("Attack", "Heal", "Effect") var type:String

func use_ability() -> void:
	pass
