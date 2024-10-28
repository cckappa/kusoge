class_name Talking
extends Node2D

@export var talking_area:Area2D
@export var timeline_name:String
var talking:=false
var talking_zone:=false

func _ready() -> void:
	talking_area.connect("body_entered", entra_area)
	talking_area.connect("body_exited", sale_area)

func start_dialog() -> void:
	talking = true
	SignalBus.emit_signal("starts_talking")
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(timeline_name)

func _on_timeline_ended() -> void:
	talking = false
	SignalBus.emit_signal("stops_talking")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	print("termina de hablar")

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("talks") and talking_zone and !talking:
		start_dialog()
		print("empieza a hablar")

func entra_area(body:Node2D) -> void:
	if body.is_in_group("main_character"):
		print(body.name)
		talking_zone = true

func sale_area(body:Node2D) -> void:
	if body.is_in_group("main_character"):
		print(body.name)
		talking_zone = false
