extends HBoxContainer

func set_neighbours() -> void:
	var index := 0
	if get_child_count() == 0:
		return
	
	for child in get_children():
		child.find_child("TargetButton").focus_neighbor_left = get_child((index - 1) % get_child_count()).find_child("TargetButton").get_path()
		child.find_child("TargetButton").focus_neighbor_right = get_child((index + 1) % get_child_count()).find_child("TargetButton").get_path()
		index += 1
