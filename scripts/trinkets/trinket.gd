class_name Trinket
extends Resource

@export var identifier:StringName
@export var section_folder:String
@export var icon:Texture2D=preload("res://assets/icons/warning.png") # Update to a valid path or placeholder
@export var model3d:PackedScene

@export_enum(
	"NORMAL", 
	"FIRE", 
	"WATER", 
	"ELECTRIC", 
	"EARTH", 
	"ICE", 
	"WIND", 
	"GRASS") var type: String = "NORMAL"

var display_name: String:
	get:
		return tr("%s/%s/name" % [section_folder, identifier])

var description: String:
	get:
		return tr("%s/%s/description" % [section_folder, identifier])
