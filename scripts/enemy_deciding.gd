extends BattleStateEnemy

@export var run:Button
@export var fight:Button

func enter(previous_state_path: String, data := {}) -> void:
	run.connect("pressed", start_running)
	fight.connect("pressed", start_fighting)

func start_running() -> void:
	pass

func start_fighting() -> void:
	run.disconnect("pressed", start_running)
	fight.disconnect("pressed", start_fighting)
	finished.emit(ATTACKING)
