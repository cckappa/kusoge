extends Node

var player_position:=Vector2(192,454)

var party:Array[Character]
var target:=[]
var main_enemy:EnemyResource
var current_enemies:Array[EnemyResource]
var current_characters:Array[Character]
var extra_enemies:Array[EnemyResource]
var target_marker:String = "default"
var from_door:bool = false

const ALICIA := preload("res://assets/resources/characters/alicia.tres")
const INGENIERO_FROGELIO = preload("res://assets/resources/characters/demo_tecnico/ingeniero_frogelio.tres")
const MALENA = preload("res://assets/resources/characters/demo_tecnico/malena.tres")
const MIUMIU = preload("res://assets/resources/characters/demo_tecnico/miumiu.tres")
const PROTO_SHAMAN = preload("res://assets/resources/characters/demo_tecnico/proto_shaman.tres")
const RANASTACIO = preload("res://assets/resources/characters/demo_tecnico/ranastacio.tres")
const SABIA_RANA_PEDRO = preload("res://assets/resources/characters/demo_tecnico/sabia_rana_pedro.tres")
const LOBUKI = preload("res://assets/resources/characters/demo_tecnico/lobuki.tres")


var ene_1 := preload("res://assets/resources/enemies/plant_enemy.tres")
var ene_2 := preload("res://assets/resources/enemies/silla.tres")
var enemies:Array[Character]
var crit_multiplier:= 1.5

var current_arrange : Dictionary = {
	"left": null,
	"up": null,
	"right": null,
	"down": null,
	"joypad_1": null,
	"joypad_2": null,
	"joypad_3": null,
	"joypad_4": null
}

var current_arrange_allies : Dictionary = {
	"left": null,
	"up": null,
	"right": null,
	"down": null,
}

var current_arrange_enemies : Dictionary = {
	"joypad_1": null,
	"joypad_2": null,
	"joypad_3": null,
	"joypad_4": null
}

var full_maps_resource := preload("res://assets/resources/maps/full_maps.tres")
var maps :Dictionary 

var current_map_name:String
var current_map_path:String

var key_variables:Dictionary={}
var win_stakes:Dictionary={
	"key_variable_key": "",
	"key_variable_value": ""
}

func _ready() -> void:
	setup_globals()
	if OS.is_debug_build():
		reset_lives()

func setup_globals() -> void:
	maps = full_maps_resource.get_maps_dictionary()
	ene_1.current_hp = ene_1.max_hp
	ene_2.current_hp = ene_2.max_hp
	party = [MIUMIU, PROTO_SHAMAN, LOBUKI, SABIA_RANA_PEDRO]
	set_current_characters([ALICIA, RANASTACIO, MALENA, INGENIERO_FROGELIO])
	enemies = [ene_1, ene_2]

func set_current_enemies(enemy:EnemyResource, _extra_enemies:Array[EnemyResource] = []) -> void:
	if main_enemy == null:
		main_enemy = enemy
		current_enemies = [enemy]
		if _extra_enemies.size() != 0:
			current_enemies.append_array(_extra_enemies)
			extra_enemies = _extra_enemies

func clear_current_enemies() -> void:
	main_enemy = null
	current_enemies.clear()
	enemies.clear()
	current_arrange_enemies = {
		"joypad_1": null,
		"joypad_2": null,
		"joypad_3": null,
		"joypad_4": null
	}
	if extra_enemies.size() != 0:
		extra_enemies.clear()

func set_target(_target:Array) -> void:
	target = _target

func set_current_characters(characters:Array[Character]) -> void:
	current_characters = characters

func get_current_characters() -> Array[Character]:
	return current_characters

func clear_current_characters() -> void:
	current_characters.clear()

func remove_character_from_current_characters(character:Character) -> void:
	current_characters.erase(character)

func reset_lives() ->void:
	## TODO: Cambiar a una funcion que resete la vida de tu party a 1hp
	for character in current_characters:
		if character.current_hp == -1:
			character.set_current_hp()
		if OS.is_debug_build():
			character.set_current_hp()
	
	for character in party:
		if character.current_hp == -1:
			character.set_current_hp()
		if OS.is_debug_build():
			character.set_current_hp()

func set_otk() -> void:
	for character in current_characters:
		if character.current_hp <= 0:
			character.set_current_hp(character.max_hp)
	clear_current_enemies()


func switch_favorite_places(from_index:int, to_index:int) -> void:
	var from_character := current_characters[from_index]
	var to_character := current_characters[to_index]
	
	current_characters[from_index] = to_character
	current_characters[to_index] = from_character

func switch_friend_to_favorite(from_index:int, to_index:int) -> void:
	var from_character := party[from_index]
	var to_character := current_characters[to_index]
	
	party[from_index] = to_character
	current_characters[to_index] = from_character

func switch_favorite_to_friend(from_index:int, to_index:int) -> void:
	var from_character := current_characters[from_index]
	var to_character := party[to_index]
	
	current_characters[from_index] = to_character
	party[to_index] = from_character

func set_win_stakes(key_name:String, key_value:String) -> void:
	win_stakes.key_variable_key = key_name
	win_stakes.key_variable_value = key_value

func apply_win_stakes() -> void:
	if win_stakes.key_variable_key != "" and win_stakes.key_variable_value != "":
		key_variables[win_stakes.key_variable_key] = win_stakes.key_variable_value
		win_stakes.key_variable_key = ""
		win_stakes.key_variable_value = ""
