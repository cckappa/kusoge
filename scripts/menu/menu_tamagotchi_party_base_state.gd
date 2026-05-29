extends LimboState

@onready var party_grid_container := %PartyGridContainer
@onready var full_party_grid_container := %FullPartyGridContainer

const MENU_PARTY_MEMBER_CONTAINER_PATH := "res://scenes/menu/menu_party_member_container.tscn"
const MENU_PARTY_MISSING_CONTAINER_PATH := "res://scenes/menu/menu_missing_party.tscn"

func _setup() -> void:
	# SignalBus.connect("menu_member_character_button_pressed", _to_member_state)
	SignalBus.connect("menu_party_character_button_pressed", _to_party_state)
	SignalBus.connect("character_unlocked", _new_character)
	_free_children()
	add_party_members()
	
func _enter() -> void:
	var cargo: MarginContainer = get_cargo()
	
	blackboard.get_var("party_control").visible = true
	blackboard.get_var("member_description_control").visible = true
	blackboard.get_var("pov_container").move_party()
	if cargo != null:
		cargo.get_child(0).grab_focus()
	else:
		party_grid_container.get_child(0).get_child(0).grab_focus()
	
	for _character: Character in Globals.current_characters:
		if _character.unlocked:
			print("Current character: ", _character.name, ", id: ", _character.character_id)
	for _character: Character in Globals.party:
		if _character.unlocked:
			print("Party character: ", _character.name, ", id: ", _character.character_id)

func _input(event: InputEvent) -> void:
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

	var sorted_current_characters: Array[Character] = []
	sorted_current_characters.resize(4)
	sorted_current_characters.fill(null)

	for character in Globals.current_characters:
		if character.unlocked and character.character_id < 4:
			sorted_current_characters[character.character_id] = character

	var j := 0
	for character in sorted_current_characters:
		if character != null:
			var party_member_container_instance := party_member_container.instantiate()
			party_grid_container.add_child(party_member_container_instance)
			party_member_container_instance.setup_info(character)
		else:
			var party_member_container_instance := party_member_container.instantiate()
			party_grid_container.add_child(party_member_container_instance)
			party_member_container_instance.setup_info(null, j)
		j += 1
	

	var sorted_party: Array[Character] = []
	sorted_party.resize(30)
	sorted_party.fill(null)

	for character in Globals.party:
		if character.unlocked:
			sorted_party[character.character_id] = character

	var i := 0
	for character: Character in sorted_party:
		if character != null and character.unlocked:
			var party_member_container_instance := party_member_container.instantiate()
			full_party_grid_container.add_child(party_member_container_instance)
			party_member_container_instance.setup_info(character)
		else:
			var party_member_container_instance := party_member_container.instantiate()
			full_party_grid_container.add_child(party_member_container_instance)
			party_member_container_instance.setup_info(null, i)
		i += 1
	

func _to_party_state(_character: Character, _container: MarginContainer) -> void:
	dispatch("to_party_member_option_state", {"character": _character, "container": _container})

func _new_character(_character: Character) -> void:
	_free_children()
	add_party_members()

func _sort_by_character_id(a: Character, b: Character) -> bool:
	return a.character_id < b.character_id