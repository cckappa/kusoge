extends LimboState

@onready var party_h_box_container:=%PartyHBoxContainer

func _setup() -> void:
	SignalBus.connect("party_character_button_pressed", _on_party_character_button_pressed)
	SignalBus.connect("enemies_defeated", _enemies_defeated)
	SignalBus.connect("set_alive_allies_containers", _on_set_alive_allies_containers)
	SignalBus.connect("total_party_kill", _on_total_party_kill)
	SignalBus.connect("party_character_button_focused", _on_party_character_button_focused)

func _enter() -> void:
	# get_viewport().gui_focus_changed.connect(_on_focus_changed)
	if party_h_box_container.get_child(0).name == "PartyCharacterVisualSeBorra":
		await get_tree().process_frame
	
	if blackboard.get_var("last_selected_character_texture_button") != null:
		blackboard.get_var("last_selected_character_texture_button").call_deferred("grab_focus")
	else:
		for container in party_h_box_container.get_children():
			if container.focus_party_character():
				return

# func _exit() -> void:
	# get_viewport().gui_focus_changed.disconnect(_on_focus_changed)

func _on_party_character_button_pressed(_character:Character, _container:PanelContainer) -> void:
	if is_active():
		blackboard.set_var("selected_party_member", _character)
		blackboard.set_var("selected_party_container", _container)
		blackboard.set_var("crit", blackboard.get_var("selected_party_container").get_crit())
		dispatch("to_focus_attack")

func _on_party_character_button_focused(party_container:PanelContainer) -> void:
	blackboard.set_var("last_selected_character_texture_button", party_container.selected_button)
	blackboard.set_var("selected_party_container", party_container)

func _enemies_defeated() -> void:
	if is_active():
		dispatch("to_win_state")

func _on_set_alive_allies_containers(alive_allies_containers:Array) -> void:
	if alive_allies_containers.size() > 0 and not blackboard.get_var("selected_party_container").is_alive():
		blackboard.set_var("last_selected_character_texture_button", alive_allies_containers[0].selected_button)

	if alive_allies_containers.size() > 0 and is_active() and not blackboard.get_var("selected_party_container").is_alive():
		blackboard.get_var("last_selected_character_texture_button").call_deferred("grab_focus")

func _on_total_party_kill() -> void:
	if is_active():
		dispatch("to_lose_state")
