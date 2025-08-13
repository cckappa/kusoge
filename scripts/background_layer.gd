@tool
extends Node2D
class_name BackgroundLayer

# IT SHOULD TURN ON Z-INDEX WHEN THE PROJECT STARTS SO THAT IT SHOWS THE OBJECTS CORRECTLY BEHIND THE BACKGROUND IMAGE

func _ready() -> void:
    z_index = -1
