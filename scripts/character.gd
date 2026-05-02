class_name Character
extends Resource

@export_group("Character Info")
@export var identifier:String
@export var section_folder:String
var name:String:
	get:
		return tr("%s/%s/name" % [section_folder,identifier])
var description:String:
	get:
		return tr("%s/%s/description" % [section_folder,identifier])
@export var character_portrait:Texture
@export var character_damaged:Texture
@export var max_hp:int
@export var unlocked:bool = false

@export_group("Abilities")
@export_enum(
	"NORMAL", 
	"FIRE", 
	"WATER", 
	"ELECTRIC", 
	"EARTH", 
	"ICE", 
	"WIND", 
	"GRASS") var type: String = "NORMAL"
@export var abilities:Array[Ability]

@export_group("Loot")
@export var loot:Array[Item]
@export var min_loot:int = 0
@export var max_loot:int = 1

@export_group("Battle Dialogs")
@export var special_encounter:=false
@export var fight_dialogs:Array[FightDialog]

var current_hp:=-1
var current_abilities:Array[Ability]
var current_container:CharacterContainer
var disabled:bool=false

func set_current_hp(hp:int=-1) -> void:
	if hp == -1:
		current_hp = max_hp
	else:
		current_hp = hp

func reduce_health(hp:int, crit:bool=false) -> void:
	if !disabled:
		current_hp = clamp(current_hp - hp, 0, max_hp)
	
	if current_hp <= 0:
		disabled = true

	if current_container != null:
		current_container.set_health(current_hp, "DAMAGE", crit)

func increase_health(hp:int, crit:bool=false) -> void:
	if !disabled:
		current_hp = clamp(current_hp + hp, 0, max_hp)

	if current_hp <=0:
		disabled = true
	
	if current_container != null:
		current_container.set_health(current_hp, "HEAL", crit)

func add_loot_to_item_list() -> Array[Dictionary]:
	var added_loot:Array[Dictionary]
	
	for item in loot:
		var rand:= randi_range(min_loot, max_loot)
		if rand > 0:
			item.add_to_items(rand)
			added_loot.append({"resource": item, "total": rand})
	
	return added_loot
	

func get_intro_dialog() -> EnemyFightDialog:
	if fight_dialogs.size() == 0:
		return null

	var intro_dialogs := []
	for dialog in fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.INTRO:
			intro_dialogs.append(dialog)

	return intro_dialogs.pick_random()

func get_health_trigger_dialogs() -> Array[EnemyFightDialog]:
	if fight_dialogs.size() == 0:
		return []

	var health_dialogs :Array[EnemyFightDialog] = []
	for dialog in fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.HEALTH_TRIGGER:
			health_dialogs.append(dialog)

	if health_dialogs.size() == 0:
		return []
	
	return health_dialogs

func get_victory_dialog() -> EnemyFightDialog:
	if fight_dialogs.size() == 0:
		return null
	
	var victory_dialogs :Array[EnemyFightDialog] = []
	for dialog in fight_dialogs:
		if dialog.dialog_type == EnemyFightDialog.DialogType.VICTORY:
			victory_dialogs.append(dialog)

	if victory_dialogs.size() == 0:
		return null

	return victory_dialogs.pick_random()
