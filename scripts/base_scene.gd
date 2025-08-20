class_name BaseScene
extends Node2D

@export var audio_stream_player: AudioStreamPlayer

const BATTLE = preload("res://scenes/battle.tscn")
var playable_character: Node2D
var camera2D: PhantomCamera2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SignalBus.connect("starts_fighting", add_fight)
	if y_sort_enabled != true:
		y_sort_enabled = true
	
	set_character_position()
	_ready_scene()

func _ready_scene() -> void:
	pass

func add_fight() -> void:
	var battle_scene := BATTLE.instantiate()
	add_child(battle_scene)

func set_character_position() -> void:
	if not Globals.from_door:
		return

	if Globals.target_marker == "default":
		var default_marker := get_node("SpawnsLayer/DefaultMarker")
		if default_marker:
			# camera2D = get_node("CameraManager").current_camera
			# camera2D.position = default_marker.position
			playable_character = get_node("PlayableCharacter")
			playable_character.position = default_marker.position
			print("Default marker position set to:", Globals.target_marker)
	else:
		var target_marker := get_node("SpawnsLayer/" + Globals.target_marker)
		if not target_marker:
			print("Target marker not found:", Globals.target_marker)
			return
		# camera2D = get_node("CameraManager").current_camera
		# camera2D.position = target_marker.position
		playable_character = get_node("PlayableCharacter")
		playable_character.position = target_marker.position
		Globals.target_marker = "default"  # Reset to default after setting position
		print("Target marker position set to:", Globals.target_marker)

	Globals.from_door = false