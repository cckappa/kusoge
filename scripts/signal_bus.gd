extends Node

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
