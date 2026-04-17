extends HBoxContainer

@onready var item_selected:=$ItemSelected
@onready var item_text:=$ItemText
var item_resource:Item

func _ready() -> void:
	item_selected.text = ""

func setup_info(_item:Dictionary, _quantity:int) -> void:
	item_resource = _item.resource
	item_text.text = "{quantity} {name}".format({"name":_item.resource.display_name,"quantity":str(_quantity)})


func _on_focus_entered() -> void:
	SignalBus.emit_signal("menu_item_focus_entered", item_resource)
	item_selected.text = "*"

func _on_focus_exited() -> void:
	item_selected.text = ""
