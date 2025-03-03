class_name QuestResource
extends Resource

@export var name:String
@export var description_list:Array[String]

enum QuestStatus{
	AVAILABLE,
	STARTED,
	REACHED_GOAL,
	FINISHED
}

var quest_status:QuestStatus = QuestStatus.AVAILABLE

func add_reward() -> void:
	pass
