extends Node

signal changing_scene
signal settings_discarded
signal starts_talking
signal stops_talking
signal starts_fighting
signal finishes_fighting

## OVERWORLD

signal wild_enemy_encounter

## FIGHTING

signal damaged(value_hp:float, character:Character)
signal healed(value_hp:float, character:Character)
signal crits_signal()
signal stop_crit()
signal action_selected(action:StringName)
signal attack_menu_opened()
signal item_menu_opened()
signal menu_closed(from:Character)
signal item_menu_closed(from:Character)
signal ability_button_pressed(from:Character, attack:Ability)
signal item_button_pressed(from:Character, item:Item)
signal run_away()

## QUESTS

signal quest_added(quest:QuestResource)
signal quest_goal(quest:QuestResource)
signal quest_finished(quest:QuestResource)

## ITEMS

signal item_added(item:Item)
signal item_removed(item:Item)

## CHARACTERS

signal character_unlocked(character:Character)