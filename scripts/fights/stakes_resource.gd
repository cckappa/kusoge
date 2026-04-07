extends Resource
class_name StakesResource

@export var key_name:StringName
@export var key_value:bool

@export var map_name:StringName
@export var win_map_value:StringName
@export var lose_map_value:StringName
@export_enum("key", "map_state", "multiple") var type:String="key"
