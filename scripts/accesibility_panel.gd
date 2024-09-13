extends PausePanel

@export var animated_checkbox:CheckBox
@export var scale_spinbox:SpinBox
@export var speed_spinbox:SpinBox

func _ready_scene() -> void:
	animated_checkbox.connect("toggled", save_animated)
	scale_spinbox.connect("value_changed", save_scale)
	speed_spinbox.connect("value_changed", save_speed)

func _apply_settings() -> void:
	animated_checkbox.button_pressed = accesibility_settings.animated_text
	scale_spinbox.value = accesibility_settings.scale_text
	speed_spinbox.value = accesibility_settings.speed_text

func save_animated(toggled_on:bool) -> void:
	save_setting("accesibility", "animated_text", toggled_on)

func save_scale(value:float) -> void:
	save_setting("accesibility", "scale_text", value)

func save_speed(value:float) -> void:
	save_setting("accesibility", "speed_text", value)
