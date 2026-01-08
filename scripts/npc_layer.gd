@tool
extends Node2D
class_name NpcLayer

@export_tool_button("Create NPC")
var create_npc_button: = create_npc
@export_tool_button("Create Gray Box NPC")
var create_gray_box_npc_button: = create_gray_box_npc

func _ready() -> void:
    y_sort_enabled = true


func create_npc() -> void:
    if Engine.is_editor_hint():
        print('Creating NPC...')
        var npc_scene := load("res://scenes/npc.tscn")
        var npc_instance :Node= npc_scene.instantiate()
        add_child(npc_instance)
        npc_instance.owner = get_tree().edited_scene_root
        get_tree().edited_scene_root.set_editable_instance(npc_instance, true)
        print('NPC created:', npc_instance.name)
    else:
        print('This function can only be used in the editor.')
        return

func create_gray_box_npc() -> void:
    if Engine.is_editor_hint():
        print('Creating Gray Box NPC...')
        var gray_box_npc_scene := load("res://scenes/gray_box_npc.tscn")
        var gray_box_npc_instance :Node= gray_box_npc_scene.instantiate()
        add_child(gray_box_npc_instance)
        gray_box_npc_instance.owner = get_tree().edited_scene_root
        get_tree().edited_scene_root.set_editable_instance(gray_box_npc_instance, true)
        print('Gray Box NPC created:', gray_box_npc_instance.name)
    else:
        print('This function can only be used in the editor.')
        return