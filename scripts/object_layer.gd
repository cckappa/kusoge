@tool
extends Node2D
class_name ObjectLayer
@export_tool_button("Create Object")
var create_object_button: = create_object
@export_tool_button("Create Gray Box")
var create_gray_box_button: = create_gray_box


func _ready() -> void:
    y_sort_enabled = true

func create_object() -> void:
    if Engine.is_editor_hint():
        print('Creating Object...')
        var object_scene := load("res://scenes/objeto.tscn")
        var object_instance: Node = object_scene.instantiate()
        add_child(object_instance)
        object_instance.owner = get_tree().edited_scene_root
        get_tree().edited_scene_root.set_editable_instance(object_instance, true)
        print('Object created:', object_instance.name)
    else:
        print('This function can only be used in the editor.')
        return

func create_gray_box() -> void:
    if Engine.is_editor_hint():
        print('Creating Gray Box...')
        var gray_box_scene := load("res://scenes/gray_box.tscn")
        var gray_box_instance: Node = gray_box_scene.instantiate()
        add_child(gray_box_instance)
        gray_box_instance.owner = get_tree().edited_scene_root
        get_tree().edited_scene_root.set_editable_instance(gray_box_instance, true)
        print('Gray Box created:', gray_box_instance.name)
    else:
        print('This function can only be used in the editor.')
        return