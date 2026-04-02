@tool
#ARCHIVO FULL
# map_state_logic() y dialogic_logic() funcionan con el estado del mapa, que se guarda en Globals.maps[nombre_del_mapa].state

extends BaseScene

@onready var npc_basura := %NpcBasura

func _ready_scene() -> void:
	if Globals.win_stakes.get("sillas_basura"):
		Globals.set_map_state(single_map_resource.map_name, "sillas_basura")

	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"alerta_basura":
			npc_basura.find_child("Area2D").monitoring = false
		"sillas_basura":
			pass
		_:
			pass
	
func dialogic_logic(event_name:String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "alerta_basura":
		npc_basura.find_child("Area2D").monitoring = false
		Globals.set_map_state(single_map_resource.map_name, "alerta_basura")
