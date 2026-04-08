@tool
#ARCHIVO BASE
extends BaseScene

@onready var madera:= %Madera
@onready var lanzan_gatitos_trigger:= %LanzanGatitosTrigger
@onready var camara_focus_lucia:= %CamaraFocusLucia
@onready var world_animation_player:= %WorldAnimationPlayer
@onready var gana_gatito:= %GanaGatito

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func key_variable_logic() -> void:
	if Globals.key_variables.has("guarida_abierta") and Globals.key_variables["guarida_abierta"] == true:
		world_animation_player.play("guarida_abierta")
	else:
		world_animation_player.play("guarida_cerrada")

func map_state_logic() -> void:
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
			# world_animation_player.play("RESET")
		"flor_recogida":
			# world_animation_player.play("guarida_abierta")
			world_animation_player.play("set_puestos_molestar_gatito")
			print("Flor recogida, mapa actualizado a flor_recogida")
		"gana_pelea_gatito":
			gana_gatito.find_child("Talk").disabled = false
			world_animation_player.play("set_gana_pelea_gatito")
		"pierde_pelea_gatito":
			pass
		"final_memory_plaza_principal":
			world_animation_player.play("final_memory_plaza_principal")
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "abrir_guarida":
		Globals.set_key_variable("guarida_abierta", true)
	elif event_name == "cerrar_guarida":
		Globals.set_key_variable("guarida_abierta", false)
	elif event_name == "final_memory_plaza_principal":
		Globals.set_map_state(single_map_resource.map_name, "final_memory_plaza_principal")
		Globals.set_map_state("memory_guarida", "ending")

func play_juegan_con_gatito() -> void:
	world_animation_player.play("juegan_con_gatito")
	print("Playing juegan_con_gatito animation")
