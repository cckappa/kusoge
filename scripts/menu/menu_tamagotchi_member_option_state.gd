extends LimboState

@onready var agregar_member_button:=%AgregarMemberButton
@onready var atras:=%AtrasMemberButton

var character:Character

func _setup() -> void:
	atras.connect("pressed", _on_atras_pressed)
	agregar_member_button.connect("pressed", _on_agregar_member_pressed)

func _enter() -> void:
	var cargo:Character=get_cargo()
	character = cargo

	blackboard.get_var("member_options").visible = true
	agregar_member_button.grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_base_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_party_hidden_state", "pause")

func _exit() -> void:
	blackboard.get_var("member_options").visible = false

func _on_agregar_member_pressed() -> void:
	print("Agrego member: ", character)

func _on_atras_pressed() -> void:
	dispatch("to_party_base_state")
