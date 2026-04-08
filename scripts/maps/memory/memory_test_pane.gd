@tool
#ARCHIVO BASE
# map_state_logic() y dialogic_logic() funcionan con el estado del mapa, que se guarda en Globals.maps[nombre_del_mapa].state

extends BaseScene

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)
