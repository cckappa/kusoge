extends Control

@export var animation_duration: float = 2.0

@onready var item_sprite:= %ItemSprite
@onready var new_item_text:= %NewItemText
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var bbtext_start:String = "[center][wave amp=60 freq=3]"
var bbtext_end:String = "[/wave][/center]"

func _ready() -> void:
	SignalBus.connect("item_added", item_added)

func set_info(item: Item) -> void:
	item_sprite.texture = item.icon
	new_item_text.text = bbtext_start + item.display_name + bbtext_end


func item_added(item: Item) -> void:
	set_info(item)
	animation_player.play("new_item")
	await animation_player.animation_finished
	await get_tree().create_timer(animation_duration).timeout
	animation_player.play("hide_item")
