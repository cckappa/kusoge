extends Control

@onready var notification_container:VBoxContainer = %NotificationContainer

var notification_scene:PackedScene = preload("res://scenes/notification.tscn")

func _ready() -> void:
	SignalBus.connect("add_notification", _on_add_notification)

func _on_add_notification(title:String, body:String, image:Texture) -> void:
	var notification_instance:Control = notification_scene.instantiate()
	notification_container.add_child(notification_instance)
	notification_instance.set_info(title, body, image)