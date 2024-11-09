extends BattleState

@export var fight_run:HBoxContainer
@export var run:Button
@export var fight:Button

func enter(previous_state_path: String, data := {}) -> void:
	fight_run.visible = true
	run.connect("pressed", start_running)
	fight.connect("pressed", start_fighting)

func start_running() -> void:
	pass

func start_fighting() -> void:
	run.disconnect("pressed", start_running)
	fight.disconnect("pressed", start_fighting)
	fight_run.visible = false
	finished.emit(FIGHTING)
