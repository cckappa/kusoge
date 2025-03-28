class_name QuestResource
extends Resource

@export var identifier:String
@export var name:String
@export var goal_description_list:Array[String]
@export var description_list:Array[String]
@export var quest_giver:Character

enum QuestStatus {
	AVAILABLE,
	STARTED,
	REACHED_GOAL,
	FINISHED
}

var quest_status := QuestStatus.AVAILABLE
var quest_goal_index := 0

func add_quest_to_current_quests() -> void:
	if not Quests.current_quests.has(identifier):
		Quests.current_quests[identifier] = self
		SignalBus.emit_signal("quest_added", self)
	else:
		print("Quest already in current quests:", identifier)

func remove_quest_from_current_quests() -> void:
	if Quests.current_quests.has(identifier):
		Quests.current_quests.erase(identifier)
	else:
		print("Quest not found in current quests:", identifier)


func start_quest() -> void:
	pass

func reached_goal(next_index:int) -> void:
	pass

func finish_quest() -> void:
	pass

func add_reward() -> void:
	pass
