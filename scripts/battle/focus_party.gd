extends LimboState

@onready var party_h_box_container:=%PartyHBoxContainer

func _setup() -> void:
	SignalBus.connect("party_character_button_pressed", _on_party_character_button_pressed)

func _enter() -> void:
	if party_h_box_container.get_child(0).name == "PartyCharacterVisualSeBorra":
		await get_tree().process_frame
	
	for arrow:TextureButton in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_ALL

	party_h_box_container.get_child(0).call_deferred("focus_party_character")

func _exit() -> void:
	for arrow in get_tree().get_nodes_in_group("selected_arrows"):
		arrow.focus_mode = Control.FOCUS_NONE

func _on_party_character_button_pressed(_character:Character) -> void:
	if is_active():
		dispatch("to_focus_attack", _character)
