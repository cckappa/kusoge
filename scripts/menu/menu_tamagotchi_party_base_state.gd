extends LimboState

@onready var party_grid_container:=%PartyGridContainer
@onready var full_party_grid_container:=%FullPartyGridContainer

const MENU_PARTY_MEMBER_CONTAINER_PATH:="res://scenes/menu/menu_party_member_container.tscn"

func _setup() -> void:
	_free_children()
	add_party_members()
	
func _enter() -> void:
	blackboard.get_var("party_control").visible = true
	blackboard.get_var("member_description_control").visible = true
	blackboard.get_var("pov_container").move_party()
	party_grid_container.get_child(0).grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_hidden_state")

func _free_children() -> void:
	for child in full_party_grid_container.get_children():
		child.queue_free()

	for child in party_grid_container.get_children():
		child.queue_free()

func add_party_members() -> void:
	const party_member_container = preload(MENU_PARTY_MEMBER_CONTAINER_PATH)

	for character in Globals.current_characters:
		var party_member_container_instance := party_member_container.instantiate()
		party_grid_container.add_child(party_member_container_instance)
		party_member_container_instance.setup_info(character)
	
	for character in Globals.party:
		var party_member_container_instance := party_member_container.instantiate()
		full_party_grid_container.add_child(party_member_container_instance)
		party_member_container_instance.setup_info(character)
