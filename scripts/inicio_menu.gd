extends Control

const inicial := preload("res://scenes/inicial.tscn")
@export var play:Button

func _ready()->void:
	play.connect("pressed", start_game)

func start_game()->void:
	get_tree().change_scene_to_packed(inicial)
