class_name Quest
extends Node2D


@export var quest_resource:QuestResource
@export var dialogic_signal:String = ""

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument:Dictionary) -> void: 
	if dialogic_signal != "" and argument.name == dialogic_signal:
		if argument.type == "start":
			quest_resource.start_quest()
			print("Quest started:", quest_resource.identifier)
		elif argument.type == "goal":
			if argument.next_index != null:
				if argument.next_index == quest_resource.quest_goal_index + 1:
					quest_resource.reached_goal(argument.next_index)
					SignalBus.emit_signal("add_notification", quest_resource.goal_description_list[argument.next_index], quest_resource.description_list[argument.next_index], quest_resource.quest_giver.character_portrait)
			else:
				printerr("argument.next_index not provided")
		elif argument.type == "finish":
			quest_resource.finish_quest()
		elif argument.type == "print":
			print(quest_resource.quest_status)
		else:
			printerr("Unknown signal type: %s" % argument.name)
