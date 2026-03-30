extends BaseScene

@onready var mom_npc:= %MomNpc

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	match Globals.maps.memory_main_room.state:
		"default":
			pass
		"after_mom":
			mom_npc.find_child("Area2D").monitoring = false
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
	if event_name == "remove_mom_npc":
		mom_npc.find_child("Area2D").monitoring = false
		Globals.maps.memory_main_room.state = "after_mom"
