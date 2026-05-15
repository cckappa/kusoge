@tool
extends BaseScene
#ARCHIVO BASE
# map_state_logic() y dialogic_logic() funcionan con el estado del mapa, que se guarda en Globals.maps[nombre_del_mapa].state
var empuja_alicia: bool = false

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func _physics_process(_delta: float) -> void:
	if empuja_alicia:
		playable_character.velocity = Vector2.UP * playable_character.character_info.run_speed
		playable_character.move_and_slide()

func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "empuja_alicia":
		empuja_alicia = true
		await get_tree().create_timer(0.3).timeout
		empuja_alicia = false