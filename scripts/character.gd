class_name Character
extends Resource

@export_group("Character Info")
@export var name:String
@export var character_portrait:Texture
@export var character_damaged:Texture
@export var character_front:Texture
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

@export_group("Enemy Info")
@export var loot:Array[Item]
@export var min_loot:int = 0
@export var max_loot:int = 1
@export var selection:Selection

var current_hp:=-1
var armor_percent:=0.0
var current_abilities:Array[Ability]
var current_container:CharacterContainer
var disabled:bool=false

func set_current_hp(hp:int=-1) -> void:
	if hp == -1:
		current_hp = max_hp
	else:
		current_hp = hp

func reduce_health(hp:int, crit:bool=false) -> void:
	current_hp = clamp(current_hp - (hp - armor_percent), 0, max_hp)
	if current_hp <= 0:
		disabled = true

	if current_container != null:
		current_container.set_health(current_hp, "DAMAGE", crit)

func increase_health(hp:int, crit:bool=false) -> void:
	current_hp = clamp(current_hp + hp, 0, max_hp)
	
	if current_container != null:
		current_container.set_health(current_hp, "HEAL", crit)

func add_armor(armor:float, crit:bool=false) -> void:
	armor_percent = armor

func reset_armor() -> void:
	armor_percent = 0.0
	print("armor reset: ", armor_percent)

func add_loot_to_item_list() -> Array[Dictionary]:
	var added_loot:Array[Dictionary]
	
	for item in loot:
		var rand:= randi_range(min_loot, max_loot)
		if rand > 0:
			item.add_to_items(rand)
			added_loot.append({"display_name": item.display_name, "total": rand})
	
	return added_loot
	
