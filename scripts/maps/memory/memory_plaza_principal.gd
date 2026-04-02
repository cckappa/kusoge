@tool
#ARCHIVO BASE
extends BaseScene

@onready var madera:= %Madera
@onready var world_animation_player:= %WorldAnimationPlayer

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
		"abrir_guarida":
			world_animation_player.play("guarida_abierta")
		"cerrar_guarida":
			world_animation_player.play("guarida_cerrada")
		"flor_recogida":
			world_animation_player.play("guarida_abierta")
			world_animation_player.play("set_puestos_molestar_gatito")
			world_animation_player.play("juegan_con_gatito")
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "abrir_guarida":
		Globals.set_map_state(single_map_resource.map_name, "abrir_guarida")
	elif event_name == "cerrar_guarida":
		Globals.set_map_state(single_map_resource.map_name, "cerrar_guarida")
