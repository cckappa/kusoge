extends PanelContainer

@onready var item_name:= %ItemName
@onready var item_amount:= %ItemAmount
@onready var item_button:= %ItemButton

var item:Item
var amount:int

func set_item_info(_item: Item, _amount: int) -> void:
	item = _item
	amount = _amount
	item_name.text = item.display_name
	item_amount.text = "x%s" % str(amount)

func _on_item_button_focus_entered() -> void:
	SignalBus.emit_signal("item_name_focus_entered", item)
	item_name.text = "[wave amp=20 freq=5 connected=1]%s" % item.display_name
	item_amount.text = "[wave amp=20 freq=5 connected=1]x%s" % str(amount)

func _on_item_button_focus_exited() -> void:
	item_name.text = item.display_name
	item_amount.text = "x%s" % str(amount)
