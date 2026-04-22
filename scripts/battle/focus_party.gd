extends LimboState

@onready var party_h_box_container:=%PartyHBoxContainer

func _setup() -> void:
	SignalBus.connect("party_character_button_pressed", _on_party_character_button_pressed)
	SignalBus.connect("enemies_defeated", _enemies_defeated)

func _enter() -> void:
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	if party_h_box_container.get_child(0).name == "PartyCharacterVisualSeBorra":
		await get_tree().process_frame
	
	if blackboard.get_var("last_selected_character_texture_button") != null:
		blackboard.get_var("last_selected_character_texture_button").call_deferred("grab_focus")
	else:
		party_h_box_container.get_child(0).call_deferred("focus_party_character")

func _exit() -> void:
	get_viewport().gui_focus_changed.disconnect(_on_focus_changed)

func _on_party_character_button_pressed(_character:Character, _container:PanelContainer) -> void:
	if is_active():
		blackboard.set_var("selected_party_member", _character)
		blackboard.set_var("selected_party_container", _container)
		blackboard.set_var("crit", blackboard.get_var("selected_party_container").get_crit())
		dispatch("to_focus_attack")

func _on_focus_changed(control: Control) -> void:
	blackboard.set_var("last_selected_character_texture_button", control)

func _enemies_defeated() -> void:
	if is_active():
		dispatch("to_win_state")
