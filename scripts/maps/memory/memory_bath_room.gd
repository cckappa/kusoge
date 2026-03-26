#ARCHIVO BASE
extends BaseScene

func _ready_scene() -> void:
	# Set the map state based on the global variable
	# Se crea un mapa en assets/resources/maps/full_maps.tres
	# Lo guardas y ya puedes acceder a el con Globals.maps
	# match Globals.maps.memory_main_room.state:
	# 	"default":
	# 		pass
	# 	_:
	# 		pass

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
