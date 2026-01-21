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

func get_health_trigger_dialogs() -> Array[EnemyFightDialog]:
	if enemy_fight_dialogs.size() == 0:
		return []

	var health_dialogs :Array[EnemyFightDialog] = []
	for dialog in enemy_fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.HEALTH_TRIGGER:
			health_dialogs.append(dialog)

	if health_dialogs.size() == 0:
		return []
	
	return health_dialogs

func get_victory_dialog() -> EnemyFightDialog:
	if enemy_fight_dialogs.size() == 0:
		return null
	
	var victory_dialogs :Array[EnemyFightDialog] = []
	for dialog in enemy_fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.VICTORY:
			victory_dialogs.append(dialog)

	if victory_dialogs.size() == 0:
		return null

	return victory_dialogs.pick_random()
