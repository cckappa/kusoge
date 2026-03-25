extends Control

@export var menu_sub_viewport : SubViewportContainer 

@onready var tamagotchi := %Tamagotchi
@onready var button_items := %ButtonItems
@onready var button_trinkets := %ButtonTrinkets
@onready var button_quests := %ButtonQuests
@onready var button_corazon := %ButtonCorazon
@onready var button_tierra := %ButtonTierra
@onready var button_options := %ButtonOptions
@onready var button_back := %ButtonBack

@onready var item_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/items
@onready var trinket_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/trinkets
@onready var quest_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/quests
@onready var corazon_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/corazon
@onready var tierra_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/tierra
@onready var options_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/boton_derecho
@onready var back_button_model := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/boton_izquierdo

@onready var wiggle_bone := $Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/DMWBWiggleRotationModifier3D

@onready var items_container := %ItemsContainer
@onready var party_container := %PartyContainer

var boton_brillando := preload("res://assets/materials/boton_brillando.tres")
var max_shake_torque := 1.0
var min_shake_torque := 0.2

func _ready() -> void:
	menu_sub_viewport.connect("toggle_menu_signal", toggle_menu)

func toggle_menu(_is_visible: bool) -> void:
	if _is_visible:
		button_items.grab_focus()
	else:
		button_items.release_focus()

func _on_button_items_focus_entered() -> void:
	item_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))
	items_container.visible = true

func _on_button_items_focus_exited() -> void:
	item_button_model.set_surface_override_material(0, null)
	items_container.visible = false

func _on_button_trinkets_focus_entered() -> void:
	trinket_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_trinkets_focus_exited() -> void:
	trinket_button_model.set_surface_override_material(0, null)

func _on_button_quests_focus_entered() -> void:
	quest_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_quests_focus_exited() -> void:
	quest_button_model.set_surface_override_material(0, null)

func _on_button_corazon_focus_entered() -> void:
	corazon_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))
	party_container.visible = true

func _on_button_corazon_focus_exited() -> void:
	corazon_button_model.set_surface_override_material(0, null)
	party_container.visible = false

func _on_button_tierra_focus_entered() -> void:
	tierra_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_tierra_focus_exited() -> void:
	tierra_button_model.set_surface_override_material(0, null)

func _on_button_options_focus_entered() -> void:
	options_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_options_focus_exited() -> void:
	options_button_model.set_surface_override_material(0, null)

func _on_button_back_focus_entered() -> void:
	back_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_back_focus_exited() -> void:
	back_button_model.set_surface_override_material(0, null)

func _on_button_back_pressed() -> void:
	menu_sub_viewport.toggle_menu()

func get_random_vector_3(_min:float, _max:float) -> Vector3:
	var x := randf_range(_min, _max)
	var y := randf_range(_min, _max)
	var z := randf_range(_min, _max)
	return Vector3(x, y, z)
