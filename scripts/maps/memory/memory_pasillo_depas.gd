@tool
extends BaseScene

@onready var lucia:= %Lucia

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"huevo_podrido":
			set_status_huevo_podrido()
		_:
			pass

func dialogic_logic(event_name:String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "huevo_podrido":
		Globals.set_map_state(single_map_resource.map_name, "huevo_podrido")

func set_status_huevo_podrido() -> void:
	lucia.find_child("Area2D").monitoring = false
	lucia.visible = false