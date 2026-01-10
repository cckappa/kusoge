class_name EnemyResource
extends Character

@export var enemy_fight_dialogs:Array[EnemyFightDialog]

func get_intro_dialog() -> EnemyFightDialog:
	if enemy_fight_dialogs.size() == 0:
		return null

	var intro_dialogs := []
	for dialog in enemy_fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.INTRO:
			intro_dialogs.append(dialog)

	return intro_dialogs.pick_random()