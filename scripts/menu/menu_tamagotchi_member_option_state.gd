extends LimboState

@onready var party_grid_container:=%PartyGridContainer
@onready var full_party_grid_container:=%FullPartyGridContainer
@onready var agregar_member_button:=%AgregarMemberButton
@onready var atras:=%AtrasMemberButton

const MENU_PARTY_MEMBER_CONTAINER_PATH:="res://scenes/menu/menu_party_member_container.tscn"
const MENU_PARTY_MISSING_CONTAINER_PATH:="res://scenes/menu/menu_missing_party.tscn"

var character:Character

func _setup() -> void:
	atras.connect("pressed", _on_atras_pressed)
	agregar_member_button.connect("pressed", _on_agregar_member_pressed)

func _enter() -> void:
	var cargo:Character=get_cargo()
	character = cargo

	blackboard.get_var("member_options").visible = true
	agregar_member_button.grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_base_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_party_hidden_state", "pause")

func _exit() -> void:
	blackboard.get_var("member_options").visible = false

func _on_agregar_member_pressed() -> void:
	var missing_party := party_grid_container.find_child("MenuMissingParty*",true, false)
	print("Missing party: ", missing_party)
	for child in party_grid_container.get_children():
		print(child.name)
	if missing_party != null:
		missing_party.queue_free()
	
	const party_member_container = preload(MENU_PARTY_MEMBER_CONTAINER_PATH)
	var party_member_container_instance := party_member_container.instantiate()
	party_grid_container.add_child(party_member_container_instance)
	party_member_container_instance.type = party_member_container_instance.button_type.PARTY
	party_member_container_instance.setup_info(character)
	print("Agrego member: ", character)

func _on_atras_pressed() -> void:
	dispatch("to_party_base_state")
