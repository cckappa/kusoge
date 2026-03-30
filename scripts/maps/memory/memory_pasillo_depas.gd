extends BaseScene

@onready var lucia:= %Lucia

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	# set_status_nombre_de_estado()
	match Globals.maps.memory_pasillo_depas.state:
		"default":
			pass
		"huevo_podrido":
			set_status_huevo_podrido()
		_:
			pass


	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func _on_dialogic_signal(argument:Dictionary) -> void:
	if not argument.has("name"):
		print("Dialogic signal received without 'name' key:", argument)
		return

	var event_name :String = argument.name

	print("Dialogic text signal received:", event_name)
	if event_name == "huevo_podrido":
		Globals.maps.memory_pasillo_depas.state = "huevo_podrido"

func set_status_huevo_podrido() -> void:
	lucia.find_child("Area2D").monitoring = false
	lucia.visible = false