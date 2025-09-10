class_name BaseScene
extends Node2D

@export var current_scene: String
@export var room_state: String = "default"
@export var audio_stream_player: AudioStreamPlayer
@export var black_rect: ColorRect


const BATTLE = preload("res://scenes/battle.tscn")
var playable_character: Node2D
var camera2D: PhantomCamera2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SignalBus.connect("starts_fighting", add_fight)
	SignalBus.connect("quit_game", quit_game)
	if y_sort_enabled != true:
		y_sort_enabled = true

	set_map_information()

	set_character_position()
	_ready_scene()

func _ready_scene() -> void:
	pass

func add_fight() -> void:
	var battle_scene := BATTLE.instantiate()
	add_child(battle_scene)

func set_map_information() -> void:
	Globals.current_map_path = current_scene

func set_character_position() -> void:
	if not Globals.from_door:
		return

	if Globals.target_marker == "default":
		var default_marker := get_node("SpawnsLayer/DefaultMarker")
		if default_marker:
			playable_character = get_node("PlayableCharacter")
			playable_character.position = default_marker.position
			# print("Default marker position set to:", Globals.target_marker)
	else:
		var target_marker := get_node("SpawnsLayer/" + Globals.target_marker)
		if not target_marker:
			# print("Target marker not found:", Globals.target_marker)
			return
		playable_character = get_node("PlayableCharacter")
		playable_character.position = target_marker.position
		Globals.target_marker = "default"  # Reset to default after setting position
		# print("Target marker position set to:", Globals.target_marker)

	Globals.from_door = false

func quit_game() -> void:
	print("Quitting to main menu...")
	SignalBus.emit_signal("changing_scene")
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "IN", 2)
	print("Changing to main menu scene...")
	get_tree().change_scene_to_file("res://scenes/inicio_menu.tscn")