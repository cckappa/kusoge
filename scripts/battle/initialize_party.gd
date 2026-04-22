extends LimboState

@onready var party_h_box_container:=%PartyHBoxContainer

const PARTY_CHARACTER_PATH:="res://scenes/battle/party_character_container.tscn"

func _setup() -> void:
	_free_children()
	const party_character_container := preload(PARTY_CHARACTER_PATH)
	SignalBus.connect("party_character_killed", _on_party_character_killed)

	var first_party_character_container:PanelContainer
	var last_party_character_container:PanelContainer

	var i:=0

	for character in Globals.current_characters:
		var party_character_instance := party_character_container.instantiate()
		party_h_box_container.add_child(party_character_instance)
		party_character_instance.call_deferred("set_info",character)

		if Globals.current_characters.size() > 1:
			if i==0:
				await get_tree().process_frame
				first_party_character_container = party_character_instance
			elif i == Globals.current_characters.size() - 1:
				await get_tree().process_frame
				last_party_character_container = party_character_instance
			
			i += 1
	
	if Globals.current_characters.size() > 1:
		first_party_character_container.selected_button.focus_neighbor_left = last_party_character_container.selected_button.get_path()
		last_party_character_container.selected_button.focus_neighbor_right = first_party_character_container.selected_button.get_path()
	
	await get_tree().process_frame
	party_h_box_container.size = Vector2(0,0)
	SignalBus.emit_signal("set_alive_allies_containers", party_h_box_container.get_children())

func _free_children() -> void:
	for child in party_h_box_container.get_children():
		child.queue_free()

func _on_party_character_killed() -> void:
	var alive_allies_containers := []
	for container in party_h_box_container.get_children():
		if !container.dead:
			alive_allies_containers.append(container)
	
	SignalBus.emit_signal("set_alive_allies_containers", alive_allies_containers)
