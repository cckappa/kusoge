@tool
#ARCHIVO BASE
extends BaseScene

@onready var madera:= %Madera
@onready var lanzan_gatitos_trigger:= %LanzanGatitosTrigger
@onready var camara_focus_lucia:= %CamaraFocusLucia
@onready var world_animation_player:= %WorldAnimationPlayer

func _ready_scene() -> void:
	black_rect.visible = true
	await Functions.fade_color_rect(black_rect, "OUT", 2)

func map_state_logic() -> void:
	# camara_focus_lucia.find_child("Talk").set_disabled(true)
	# camara_focus_lucia.find_child("StaticBody2D").find_child("CollisionPolygon2D").disabled = true
	match Globals.maps[single_map_resource.map_name].state:
		"default":
			pass
			# lanzan_gatitos_trigger.find_child("Talk").set_disabled(true)
		"abrir_guarida":
			world_animation_player.play("guarida_abierta")
		"cerrar_guarida":
			world_animation_player.play("guarida_cerrada")
		"flor_recogida":
			world_animation_player.play("guarida_abierta")
			world_animation_player.play("set_puestos_molestar_gatito")
		_:
			pass
	
func dialogic_logic(event_name: String) -> void:
	print("Dialogic text signal received:", event_name)
	if event_name == "abrir_guarida":
		Globals.set_map_state(single_map_resource.map_name, "abrir_guarida")
	elif event_name == "cerrar_guarida":
		Globals.set_map_state(single_map_resource.map_name, "cerrar_guarida")

func play_juegan_con_gatito() -> void:
	world_animation_player.play("juegan_con_gatito")
