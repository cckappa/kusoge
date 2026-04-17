extends LimboState

@onready var sacar_party_button:=%SacarPartyButton
@onready var atras:=%AtrasPartyButton

var character:Character

func _setup() -> void:
	atras.connect("pressed", _on_atras_pressed)
	sacar_party_button.connect("pressed", _on_sacar_party_pressed)

func _enter() -> void:
	var cargo:Character=get_cargo()
	character = cargo

	blackboard.get_var("party_options").visible = true
	sacar_party_button.grab_focus()

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("back") and is_active():
		dispatch("to_party_base_state", "back")
	elif event.is_action_pressed("pause") and is_active():
		dispatch("to_party_hidden_state", "pause")

func _exit() -> void:
	blackboard.get_var("party_options").visible = false

func _on_atras_pressed() -> void:
	dispatch("to_party_base_state")

func _on_sacar_party_pressed() -> void:
	print("Saco party: ", character)