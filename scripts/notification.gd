extends PanelContainer

@onready var notification_title:RichTextLabel = %NotificationTitle
@onready var notification_body:RichTextLabel = %NotificationBody
@onready var notification_image:TextureRect = %NotificationImage

func set_info(title:String, body:String, image:Texture) -> void:
	notification_title.text = title
	notification_body.text = body
	notification_image.texture = image

func clear_self() -> void:
	queue_free()
