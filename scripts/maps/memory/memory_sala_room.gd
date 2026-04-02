@tool
extends BaseScene

@onready var mom_npc:= %MomNpc
@onready var collision_shape_2d_salida := %CollisionShape2DSalida

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"mom_bye":
			set_status_mom_bye()
		_:
			pass

func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "mom_bye":
		set_status_mom_bye()
		Globals.set_map_state(single_map_resource.map_name, "mom_bye")

func set_status_mom_bye() -> void:
	mom_npc.find_child("Talk2").find_child("Area2D").monitoring = false
	collision_shape_2d_salida.disabled = false
