@tool
#ARCHIVO BASE
extends BaseScene

@onready var maceta_rota := %MacetaRota

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"maceta_recogida":
			set_status_maceta_recogida()
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "maceta_recogida":
		set_status_maceta_recogida()
		Globals.set_map_state(single_map_resource.map_name, "maceta_recogida")

func set_status_maceta_recogida() -> void:
	maceta_rota.find_child("Area2D").monitoring = false
	maceta_rota.find_child("CollisionShape2D").disabled = true
	maceta_rota.visible = false
