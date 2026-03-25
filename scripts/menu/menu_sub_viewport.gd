extends SubViewportContainer

var on_dialogic := false
var quit_paused := false
signal toggle_menu_signal(_is_visible:bool)

func _ready() -> void:
	SignalBus.connect("starts_talking", starts_talking)
	SignalBus.connect("stops_talking", stops_talking)
	visible = false

func _input(event:InputEvent) -> void:
	if quit_paused:
		return
	if event.is_action_pressed("pause") and not on_dialogic:
		toggle_menu()

func toggle_menu() -> void:
	if quit_paused:
		return
	visible = not visible
	
	if visible:
		pass
		# toggle_menu_signal.emit()
	else:
		pass
	
	emit_signal("toggle_menu_signal", visible)
	get_tree().paused = not get_tree().paused
	print("Menu pausado")

func starts_talking() -> void:
	on_dialogic = true

func stops_talking() -> void:
	on_dialogic = false

