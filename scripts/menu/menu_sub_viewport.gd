extends SubViewportContainer

@onready var sub_viewport := %SubViewport

var on_dialogic := false
var quit_paused := false
signal toggle_menu_signal(_is_visible:bool)