extends LimboState

@onready var party_grid_container := %PartyGridContainer
@onready var full_party_grid_container := %FullPartyGridContainer

var character: Character
var character_container: MarginContainer
var containers: Array[MarginContainer] = []

func _setup() -> void:
	SignalBus.connect("menu_party_switch_button_pressed", switch_container)

func _enter() -> void:
	var cargo: Dictionary = get_cargo()
	character = cargo.character
	character_container = cargo.container

	for member_container: MarginContainer in full_party_grid_container.get_children():
		containers.append(member_container)

	for member_container: MarginContainer in party_grid_container.get_children():
		containers.append(member_container)
	
	for member_container: MarginContainer in containers:
		if member_container.has_method("switch_focus"):
			member_container.switch_focus()
		if member_container.has_method("set_switch_info"):
			member_container.set_switch_info(cargo.character)

	
	cargo.container.switch_button.grab_focus()
	cargo.container.remove_info()


func _exit() -> void:
	for member_container: MarginContainer in containers:
		if member_container.has_method("switch_focus"):
			member_container.focus_normal()

func _update(_delta: float) -> void:
	pass

func switch_container(_character: Character, _container: MarginContainer) -> void:
	if is_active():
		if _container.member_profile.visible == false:
			_container.show_portrait()

		_container.setup_info(character)

		print("Parent Container: ", _container.get_parent())

		if _container.get_parent() == party_grid_container:
			Globals.add_character_to_current_characters(character)
			Globals.remove_character_from_party(character)
		else:
			Globals.add_character_to_party(character)
			Globals.remove_character_from_current_characters(character)

		character = _character
		character_container = _container

		for member_container: MarginContainer in containers:
			if member_container.has_method("set_switch_info"):
				if _character == null:
					dispatch("to_party_base_state", _container)
					return
				else:
					member_container.set_switch_info(_character)
