@tool
extends Node2D
class_name ObjectLayer
@export_tool_button("Create Object")
var create_object_button: = create_object


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