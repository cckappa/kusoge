#ARCHIVO BASE
extends BaseScene

@onready var madera:= %Madera
@onready var world_animation_player:= %WorldAnimationPlayer

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	# set_status_nombre_de_estado()
	match Globals.maps.memory_plaza_principal.state:
		"default":
			pass
		"abrir_guarida":
			world_animation_player.play("guarida_abierta")
		"cerrar_guarida":
			world_animation_player.play("guarida_cerrada")
		_:
			pass

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

	
func _on_dialogic_signal(argument:Dictionary) -> void:
	var event_name :String = argument.name

	print("Dialogic text signal received:", event_name)
	if event_name == "abrir_guarida":
		Globals.maps.memory_plaza_principal.state = "abrir_guarida"
	elif event_name == "cerrar_guarida":
		Globals.maps.memory_plaza_principal.state = "cerrar_guarida"
