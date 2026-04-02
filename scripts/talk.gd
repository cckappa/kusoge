class_name Talk
extends Node2D

@export var talking_area:Area2D
@export var automatic_start:bool=false
@export var timeline_name:String
@export var disabled:bool=false
@export_enum("normal", "one_shot") var talk_type: int = 0

var talking:=false
var talking_zone:=false

func _ready() -> void:
	talking_area.connect("body_entered", enters_area)
	talking_area.connect("body_exited", exits_area)
	SignalBus.connect("changing_scene", _on_changing_scene)

func start_dialog() -> void:
	talking = true
	SignalBus.emit_signal("starts_talking")
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start(timeline_name)
	print("ui_accept held: ", Input.is_action_pressed("ui_accept"))
	print("talks held: ", Input.is_action_pressed("talks"))

func _on_timeline_ended() -> void:
	talking = false
	SignalBus.emit_signal("stops_talking")
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	print("termina de hablar")
	if talk_type == 1: # one_shot
		set_disabled(true)

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("talks") and talking_zone and !talking:
		start_dialog()
		print("empieza a hablar")

func enters_area(body:Node2D) -> void:
	print("body entered: ", body.name, " disabled: ", disabled)
	if body.is_in_group("main_character") and not disabled:
		print(body.name)
		talking_zone = true
		if automatic_start and !talking:
			var press := InputEventAction.new()
			press.action = "talks"
			press.pressed = true
			Input.parse_input_event(press)
			
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			
			Input.action_release("talks")
			
			print("automatic start of dialog")
			# start_dialog()

func exits_area(body:Node2D) -> void:
	if body.is_in_group("main_character"):
		print(body.name)
		talking_zone = false

func _on_changing_scene() -> void:
	talking_area.monitoring = false

func set_disabled(value:bool) -> void:
	disabled = value
