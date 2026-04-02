@tool
extends BaseScene
# map_state_logic() y dialogic_logic() funcionan con el estado del mapa, que se guarda en Globals.maps[nombre_del_mapa].state

@onready var mom_npc:= %MomNpc

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"after_mom":
			mom_npc.find_child("Area2D").monitoring = false
		_:
			pass
	
func dialogic_logic(event_name:String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "remove_mom_npc":
		mom_npc.find_child("Area2D").monitoring = false
		Globals.set_map_state(single_map_resource.map_name, "after_mom")
