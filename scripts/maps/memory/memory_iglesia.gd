@tool
#ARCHIVO FULL
extends BaseScene

var empuja_alicia: bool = false
@onready var flor := %Flor

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func _physics_process(_delta: float) -> void:
	if empuja_alicia:
		playable_character.velocity = Vector2.DOWN * playable_character.character_info.run_speed
		playable_character.move_and_slide()

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"recoge_flor":
			set_status_recoge_flor()
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "empuja_alicia":
		empuja_alicia = true
		await get_tree().create_timer(0.3).timeout
		empuja_alicia = false
	if event_name == "recoge_flor":
		set_status_recoge_flor()
		Globals.set_map_state(single_map_resource.map_name, "recoge_flor")
		Globals.set_map_state("memory_plaza_principal", "flor_recogida")

func set_status_recoge_flor() -> void:
	flor.visible = false
	flor.find_child("Talk").set_disabled(true)
	flor.find_child("Talk2").set_disabled(true)
	flor.find_child("Talk3").set_disabled(true)