#ARCHIVO FULL
extends BaseScene

var empuja_alicia: bool = false

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	# set_status_nombre_de_estado()
	match Globals.maps.memory_iglesia.state:
		"default":
			pass
		_:
			pass

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func _physics_process(_delta: float) -> void:
	if empuja_alicia:
		playable_character.velocity = Vector2.DOWN * playable_character.character_info.run_speed
		playable_character.move_and_slide()
	
func _on_dialogic_signal(argument:Dictionary) -> void:
	var event_name :String = argument.name

	print("Dialogic text signal received:", event_name)
	if event_name == "empuja_alicia":
		empuja_alicia = true
		await get_tree().create_timer(0.3).timeout
		empuja_alicia = false
