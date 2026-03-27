#ARCHIVO FULL
extends BaseScene

@onready var npc_basura := %NpcBasura

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if Globals.win_stakes.get("sillas_basura"):
		Globals.maps.memory_bosque.state = "sillas_basura"

	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	# set_status_nombre_de_estado()
	match Globals.maps.memory_bosque.state:
		"default":
			pass
		"alerta_basura":
			npc_basura.find_child("Area2D").monitoring = false
		"sillas_basura":
			pass
		_:
			pass

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

	
func _on_dialogic_signal(argument:Dictionary) -> void:
	var event_name :String = argument.name

	print("Dialogic text signal received:", event_name)
	if event_name == "alerta_basura":
		npc_basura.find_child("Area2D").monitoring = false
		Globals.maps.memory_bosque.state = "alerta_basura"
