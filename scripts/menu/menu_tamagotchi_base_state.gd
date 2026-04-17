extends LimboState

@onready var wiggle_bone := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/DMWBWiggleRotationModifier3D

@onready var button_items := %ButtonItems
@onready var button_trinkets := %ButtonTrinkets
@onready var button_quests := %ButtonQuests
@onready var button_corazon := %ButtonCorazon
@onready var button_tierra := %ButtonTierra
@onready var button_options := %ButtonOptions
@onready var button_back := %ButtonBack

@onready var item_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/items
@onready var trinket_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/trinkets
@onready var quest_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/quests
@onready var corazon_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/corazon
@onready var tierra_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/tierra
@onready var options_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/boton_derecho
@onready var back_button_model := %Tamagotchi/AnimatableBody3D/tamagotchi2/Armature/Skeleton3D/boton_izquierdo

var boton_brillando := preload("res://assets/materials/boton_brillando.tres")

const max_shake_torque := 1.0
const min_shake_torque := 0.2

func _setup() -> void:
	button_items.connect("pressed", _on_button_items_pressed)
	button_items.connect("focus_entered", _on_button_items_focus_entered)
	button_items.connect("focus_exited", _on_button_items_focus_exited)

	button_trinkets.connect("focus_entered", _on_button_trinkets_focus_entered)
	button_trinkets.connect("focus_exited", _on_button_trinkets_focus_exited)
	button_quests.connect("focus_entered", _on_button_quests_focus_entered)
	button_quests.connect("focus_exited", _on_button_quests_focus_exited)
	
	button_corazon.connect("pressed", _on_button_corazon_pressed)
	button_corazon.connect("focus_entered", _on_button_corazon_focus_entered)
	button_corazon.connect("focus_exited", _on_button_corazon_focus_exited)
	button_tierra.connect("focus_entered", _on_button_tierra_focus_entered)
	button_tierra.connect("focus_exited", _on_button_tierra_focus_exited)
	button_options.connect("focus_entered", _on_button_options_focus_entered)
	button_options.connect("focus_exited", _on_button_options_focus_exited)

	button_back.connect("pressed", _on_button_back_pressed)
	button_back.connect("focus_entered", _on_button_back_focus_entered)
	button_back.connect("focus_exited", _on_button_back_focus_exited)

func _enter() -> void:
	button_corazon.grab_focus()
	blackboard.get_var("pov_container").move_base()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("pause") and not blackboard.get_var("talking") and is_active():
		dispatch("to_hidden_state")


func _on_button_items_pressed() -> void:
	if is_active():
		dispatch("to_item_hsm")

func _on_button_items_focus_entered() -> void:
	item_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_items_focus_exited() -> void:
	item_button_model.set_surface_override_material(0, null)



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



func _on_button_corazon_pressed() -> void:
	if is_active():
		dispatch("to_party_hsm")

func _on_button_corazon_focus_entered() -> void:
	corazon_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_corazon_focus_exited() -> void:
	corazon_button_model.set_surface_override_material(0, null)



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



func _on_button_back_pressed() -> void:
	if is_active():
		dispatch("to_hidden_state")

func _on_button_back_focus_entered() -> void:
	back_button_model.set_surface_override_material(0, boton_brillando)
	wiggle_bone.add_torque_impulse(get_random_vector_3(0.2, 1) * randf_range(min_shake_torque, max_shake_torque))

func _on_button_back_focus_exited() -> void:
	back_button_model.set_surface_override_material(0, null)



func get_random_vector_3(_min:float, _max:float) -> Vector3:
	var x := randf_range(_min, _max)
	var y := randf_range(_min, _max)
	var z := randf_range(_min, _max)
	return Vector3(x, y, z)
