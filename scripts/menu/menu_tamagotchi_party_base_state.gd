extends LimboState

@onready var party_grid_container:=%PartyGridContainer
@onready var full_party_grid_container:=%FullPartyGridContainer

const MENU_PARTY_MEMBER_CONTAINER_PATH:="res://scenes/menu/menu_party_member_container.tscn"
const MENU_PARTY_MISSING_CONTAINER_PATH:="res://scenes/menu/menu_missing_party.tscn"

func _setup() -> void:
	SignalBus.connect("menu_member_character_button_pressed", _to_member_state)
	SignalBus.connect("menu_party_character_button_pressed", _to_party_state)
	SignalBus.connect("character_unlocked", _new_character)
	_free_children()
	add_party_members()
	
func _enter() -> void:
	blackboard.get_var("party_control").visible = true
	blackboard.get_var("member_description_control").visible = true
	blackboard.get_var("pov_container").move_party()
	party_grid_container.get_child(0).get_child(0).grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_hidden_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_party_hidden_state", "pause")


func _free_children() -> void:
	for child in full_party_grid_container.get_children():
		child.queue_free()

	for child in party_grid_container.get_children():
		child.queue_free()

func add_party_members() -> void:
	const party_member_container = preload(MENU_PARTY_MEMBER_CONTAINER_PATH)
	const party_missing_container = preload(MENU_PARTY_MISSING_CONTAINER_PATH)

	for character in Globals.current_characters:
			var party_member_container_instance := party_member_container.instantiate()
			party_grid_container.add_child(party_member_container_instance)
			party_member_container_instance.type = party_member_container_instance.button_type.PARTY
			party_member_container_instance.setup_info(character)
	
	var current_party_count := Globals.current_characters.size()
	print("Fiesta con #",current_party_count)
	if current_party_count < 4:
		for i in (4 - current_party_count):
			var party_missing_container_instance := party_missing_container.instantiate()
			party_grid_container.add_child(party_missing_container_instance)

	
	for character in Globals.party:
		var party_member_container_instance := party_member_container.instantiate()
		full_party_grid_container.add_child(party_member_container_instance)
		party_member_container_instance.type = party_member_container_instance.button_type.MEMBER
		party_member_container_instance.setup_info(character)

func _to_party_state(_character:Character) -> void:
	dispatch("to_party_party_option_state", _character)

func _to_member_state(_character:Character) -> void:
	dispatch("to_party_member_option_state", _character)

func _new_character(_character:Character) -> void:
	_free_children()
	add_party_members()