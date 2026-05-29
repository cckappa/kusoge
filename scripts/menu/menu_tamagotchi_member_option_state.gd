extends LimboState

@onready var party_grid_container := %PartyGridContainer
@onready var full_party_grid_container := %FullPartyGridContainer
@onready var mover_member_button := %MoverMemberButton
@onready var atras := %AtrasMemberButton

const MENU_PARTY_MEMBER_CONTAINER_PATH := "res://scenes/menu/menu_party_member_container.tscn"
const MENU_PARTY_MISSING_CONTAINER_PATH := "res://scenes/menu/menu_missing_party.tscn"

var character: Character
var character_container: MarginContainer

func _setup() -> void:
	atras.connect("pressed", _on_atras_pressed)
	mover_member_button.connect("pressed", _on_mover_member_pressed)

func _enter() -> void:
	var cargo: Dictionary = get_cargo()
	character = cargo.character
	character_container = cargo.container

	blackboard.get_var("member_options").visible = true
	mover_member_button.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_base_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_party_hidden_state", "pause")

func _exit() -> void:
	blackboard.get_var("member_options").visible = false

func _on_mover_member_pressed() -> void:
	dispatch('to_party_moving_state', {"character": character, "container": character_container})

func _on_agregar_member_pressed() -> void:
	character_container.queue_free()
	var missing_party := party_grid_container.find_child("MenuMissingParty*", false, false)
	print("Missing party: ", missing_party)
	const party_member_container = preload(MENU_PARTY_MEMBER_CONTAINER_PATH)
	var party_member_container_instance := party_member_container.instantiate()

	if missing_party != null:
		missing_party.add_sibling(party_member_container_instance)
		missing_party.queue_free()
	else:
		party_grid_container.add_child(party_member_container_instance)

	party_member_container_instance.type = party_member_container_instance.button_type.PARTY
	party_member_container_instance.setup_info(character)
	Globals.add_character_to_current_characters(character)
	Globals.remove_character_from_party(character)
	print("Agrego member: ", character)
	print("Party: ")
	for _character: Character in Globals.current_characters:
		print(_character.name)
	
	print("Members: ")
	for _character: Character in Globals.party:
		print(_character.name)
	
	dispatch("to_party_base_state")

func _on_atras_pressed() -> void:
	dispatch("to_party_base_state")
