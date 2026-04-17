extends LimboState

@onready var party_h_box_container:=%PartyHBoxContainer

func _setup() -> void:
	SignalBus.connect("party_character_button_pressed", _on_party_character_button_pressed)

func _enter() -> void:
	if party_h_box_container.get_child(0).name == "PartyCharacterVisualSeBorra":
		await get_tree().process_frame
	party_h_box_container.get_child(0).call_deferred("focus_party_character")

func _on_party_character_button_pressed(_character:Character) -> void:
	if is_active():
		print("Presionaron: ", _character.name)
