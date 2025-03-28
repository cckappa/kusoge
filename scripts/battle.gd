extends Control

@export var character_portraits:HBoxContainer
@export var ally_container_preload := preload("res://scenes/ally_container.tscn")
@export var enemy_portraits:HBoxContainer

@onready var continue_button := %ContinueButton
@onready var quit := %Quit
@onready var next := %Next
@onready var black_rect := $BlackRect

var inicial_scene: String = "res://scenes/inicial.tscn"
var main_scene:String = "res://scenes/inicio_menu.tscn"
var character_container_size := Vector2(125, 0)
const ENEMY_CONTAINER = preload("res://scenes/enemy_container.tscn")

func _ready() -> void:
	#if OS.is_debug_build():
		#Globals.reset_lives()

	set_current_characters()
	add_characters()
	set_current_enemies()
	add_enemies()
	
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func set_current_characters() -> void:
	# Setea el orden del arrange
	Globals.current_arrange.left = Globals.current_characters[0]
	Globals.current_arrange_allies.left = Globals.current_characters[0]
	
	if Globals.party.size() > 1 and Globals.current_characters[1] != null:
		Globals.current_arrange.up = Globals.current_characters[1]
		Globals.current_arrange_allies.up = Globals.current_characters[1]
	if Globals.party.size() > 2 and Globals.current_characters[2] != null:
		Globals.current_arrange.right = Globals.current_characters[2]
		Globals.current_arrange_allies.right = Globals.current_characters[2]
	if Globals.party.size() > 3 and Globals.current_characters[3] != null:
		Globals.current_arrange.down = Globals.current_characters[3]
		Globals.current_arrange_allies.down = Globals.current_characters[3]

func add_characters() -> void:
	var key : int = 0
	for character:Character in Globals.current_arrange_allies.values():
		if character != null:
		# CharacterContainer
			var character_container := ally_container_preload.instantiate()
			character_container.name = character.name
			character_container.character = character
			character_container.max_hp = character.max_hp
			character_container.current_hp = character.current_hp
			character_container.size = character_container_size
			character_container.front_texture = character.character_front
			character_container.character_portrait = character.character_portrait
			character_container.arrange_position = key
			character_container.attack_list = character.abilities
			character_portraits.add_child(character_container)
			character_container.set_max_life(character.current_hp)
			character.current_container = character_container
			key = key + 1

func set_current_enemies() -> void:
	var enemies:= Globals.enemies.duplicate()
	Globals.current_arrange_enemies.joypad_1 = enemies[0]
	Globals.current_arrange.joypad_1 = enemies[0]
	
	if Globals.enemies.size() > 1 and enemies[1] != null:
		Globals.current_arrange_enemies.joypad_2 = enemies[1]
		Globals.current_arrange.joypad_2 = enemies[1]
	if Globals.enemies.size() > 2 and enemies[2] != null:
		Globals.current_arrange_enemies.joypad_3 = enemies[2]
		Globals.current_arrange.joypad_3 = enemies[2]
	if Globals.enemies.size() > 3 and enemies[3] != null:
		Globals.current_arrange_enemies.joypad_4 = enemies[3]
		Globals.current_arrange.joypad_4 = enemies[3]

func add_enemies() -> void:
	var key:int=0
	for enemy:Character in Globals.current_arrange_enemies.values():
		if enemy != null:
			var enemy_container := ENEMY_CONTAINER.instantiate()
			enemy_container.character = enemy
			enemy_container.name = enemy.name
			enemy_container.arrange_position = key
			enemy_portraits.add_child(enemy_container)
			enemy.current_container = enemy_container
			enemy_container.set_texture(enemy.character_portrait)
			enemy_container.set_max_life(enemy.max_hp)
			key = key + 1

	enemy_portraits.set_neighbours()


func _on_next_pressed() -> void:
	setup_cambiar("cambiar_principal")

func _on_continue_button_pressed() -> void:
	Globals.reset_lives()
	setup_cambiar("cambiar_principal")

func _on_quit_pressed() -> void:
	Globals.reset_lives()
	setup_cambiar("cambiar_main")

func setup_cambiar(scene:StringName) -> void:
	await Functions.fade_color_rect(black_rect, "IN", 2)
	call_deferred(scene)

func cambiar_principal() -> void:
	get_tree().change_scene_to_file(inicial_scene)

func cambiar_main() -> void:
	get_tree().change_scene_to_file(main_scene)
