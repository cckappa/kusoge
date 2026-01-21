class_name EnemyFightDialog
extends Resource

enum DialogType {
	INTRO,
	VICTORY,
	HEALTH_TRIGGER
}

@export var dialogic_name:String=""
@export var life_value_trigger:int=0
@export var dialog_type:DialogType=DialogType.INTRO
var triggered:bool=false
