@tool
extends Node2D
class_name NpcLayer

@export_tool_button("Create NPC")
var create_npc_button: = create_npc

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
