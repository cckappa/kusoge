extends BaseScene

@onready var mom_npc:= %MomNpc
@onready var collision_shape_2d_salida := %CollisionShape2DSalida

func _ready_scene() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	match Globals.maps.memory_sala_room.state:
		"default":
			pass
		"mom_bye":
			set_status_mom_bye()
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
	if event_name == "mom_bye":
		set_status_mom_bye()
		Globals.maps.memory_sala_room.state = "mom_bye"
	
func set_status_mom_bye() -> void:
	mom_npc.find_child("Talk2").find_child("Area2D").monitoring = false
	collision_shape_2d_salida.disabled = false
