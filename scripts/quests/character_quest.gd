class_name CharacterQuest
extends QuestResource

@export var new_character:Character

func start_quest() -> void:
	if quest_status == QuestStatus.AVAILABLE:
		quest_status = QuestStatus.STARTED
		add_quest_to_current_quests()
		print("Quest started")
	else:
		print("Quest already started")

func reached_goal(next_index:int) -> void:
	if quest_status == QuestStatus.STARTED or quest_status == QuestStatus.REACHED_GOAL:
		quest_goal_index = next_index
		quest_status = QuestStatus.REACHED_GOAL
		SignalBus.emit_signal("quest_goal", self)
		print("Quest reached goal")
	else:
		print("Quest not started")

func finish_quest() -> void:
	if quest_status == QuestStatus.STARTED or quest_status == QuestStatus.REACHED_GOAL:
		quest_status = QuestStatus.FINISHED
		print("Quest finished")
		SignalBus.emit_signal("quest_finished", self)
		add_reward()
	else:
		print("Quest not reached goal")

func add_reward() -> void:
	new_character.unlocked = true
	SignalBus.emit_signal("character_unlocked", new_character)
