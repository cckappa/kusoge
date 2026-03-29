@tool
extends EditorPlugin

var obsidian_var_graph_scene: Control

func _enter_tree():
	# Initialization of the plugin goes here.
	obsidian_var_graph_scene = preload("res://addons/obsidian_var_graph/obsidian_var_graph_scene.tscn").instantiate()
	add_control_to_bottom_panel(obsidian_var_graph_scene, "Obsidian Var Graph")


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_control_from_bottom_panel(obsidian_var_graph_scene)
	obsidian_var_graph_scene.free()
	pass
