@tool
extends Control

@onready var folder_name:= %FolderName
@onready var map_name := %MapName
@onready var var_name_input := %VarNameInput
@onready var type_value:= %TypeValue
@onready var start_value := %StartValue
@onready var values := %Values

@onready var var_name := %VarName
@onready var found_vars := %FoundVars

func _on_submit_pressed() -> void:
	var folder :String= folder_name.text.strip_edges()
	var file_name :String= map_name.text.strip_edges()
	var v_name :String= var_name_input.text.strip_edges()
	var s_value :String= start_value.text.strip_edges()
	var vals :String= values.text.strip_edges()
	var v_type :String= type_value.get_item_text(type_value.selected)

	# Basic validation
	if folder.is_empty() or file_name.is_empty() or v_name.is_empty():
		push_error("folder_name, map_name and var_name_input are required.")
		return

	var dir_path := "res://assets/obsidian_vars/tkio/maps/" + folder + "/"
	var full_path := dir_path + file_name + ".md"

	# Create directory if it doesn't exist
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	var content := ""
	var file_exists := FileAccess.file_exists(full_path)

	if file_exists:
		var f := FileAccess.open(full_path, FileAccess.READ)
		if f == null:
			push_error("Could not read file: " + full_path)
			return
		content = f.get_as_text()
		f.close()

		# Check for duplicate var_name
		for line in content.split("\n"):
			var cells := _parse_md_row(line)
			if cells.size() >= 1 and cells[0] == v_name:
				push_error("var_name already exists: " + v_name)
				return
	else:
		# Create file with header
		content = "| var_name | type | start_value | values | links |\n"
		content += "| -------- | ---- | ----------- | ------ | ----- |\n"

	# Append the new row
	var new_row := "| " + v_name + " | " + v_type + " | " + s_value + " | " + vals + " |  |"
	content = content.strip_edges() + "\n" + new_row + "\n"

	var out := FileAccess.open(full_path, FileAccess.WRITE)
	if out == null:
		push_error("Could not write file: " + full_path)
		return

	out.store_string(content)
	out.close()
	print("Var added to: ", full_path)

	# Clear inputs after success
	var_name_input.text = ""
	start_value.text = ""
	values.text = ""

func _on_find_bar_pressed() -> void:
	var search_term :String= var_name.text.strip_edges()
	print("Searching for:", search_term)
	
	if search_term.is_empty():
		print("Search term is empty.")
		return
	
	var dir_path := "res://assets/obsidian_vars/tkio/maps/"
	var results := _search_md_tables(dir_path, search_term)

	if results.is_empty():
		found_vars.text = "[i]No matches found for:[/i] [b]" + search_term + "[/b]"
		return

	found_vars.text = "[b]Results for:[/b] " + search_term + "\n" + str(results.size()) + " match(es) found."

	var container := found_vars.get_parent()

	for result in results:
		var label := RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.add_to_group("search_result")

		var text :String= "[b]" + result["var_name"] + "[/b]\n"
		text += "[color=gray]" + result["file"] + "[/color]\n"
		text += "[color=aqua]type:[/color]         " + result["type"] + "\n"
		text += "[color=aqua]start_value:[/color]  " + result["start_value"] + "\n"
		text += "[color=aqua]values:[/color]       " + result["values"]
		label.text = text
		container.add_child(label)

		# Links TextEdit
		var links_edit := TextEdit.new()
		links_edit.text = result["links"]
		links_edit.placeholder_text = "[[link_name]], [[link_name2]]"
		links_edit.custom_minimum_size = Vector2(0, 60)
		links_edit.add_to_group("search_result")
		container.add_child(links_edit)

		# Update button
		var btn := Button.new()
		btn.text = "Update Links" if not result["links"].is_empty() else "Add Links"
		btn.add_to_group("search_result")
		btn.pressed.connect(_on_update_links_pressed.bind(links_edit, result))
		container.add_child(btn)


func _search_md_tables(dir_path: String, search_term: String) -> Array:
	var matches := []
	var dir := DirAccess.open(dir_path)

	if dir == null:
		push_error("Could not open directory: " + dir_path)
		return matches

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		var full_path := dir_path + file_name

		if dir.current_is_dir():
			# Recurse into subdirectory (skip hidden dirs like "." and "..")
			if file_name != "." and file_name != "..":
				matches.append_array(_search_md_tables(full_path + "/", search_term))
		elif file_name.ends_with(".md"):
			var file_matches := _parse_md_table(full_path, search_term)
			for m in file_matches:
				m["file"] = full_path  # full path so you know which folder it came from
			matches.append_array(file_matches)

		file_name = dir.get_next()

	dir.list_dir_end()
	return matches

func _parse_md_table(file_path: String, search_term: String) -> Array:
	var matches := []
	var file := FileAccess.open(file_path, FileAccess.READ)

	if file == null:
		push_error("Could not open file: " + file_path)
		return matches

	var headers := []

	while not file.eof_reached():
		var line := file.get_line().strip_edges()

		# Skip empty lines
		if line.is_empty():
			continue

		# Skip separator rows like | --- | --- |
		if line.replace("-", "").replace("|", "").replace(" ", "").is_empty():
			continue

		# Parse cells from the row
		var cells := _parse_md_row(line)
		if cells.is_empty():
			continue

		# First valid row = headers
		if headers.is_empty():
			headers = cells
			continue

		# Build a dict from headers + cells
		var row := {}
		for i in range(min(headers.size(), cells.size())):
			row[headers[i]] = cells[i]

		# Check if var_name column contains the search term
		if row.has("var_name") and search_term.to_lower() in row["var_name"].to_lower():
			matches.append({
				"var_name":    row.get("var_name", ""),
				"type":        row.get("type", ""),
				"start_value": row.get("start_value", ""),
				"values":      row.get("values", ""),
				"links":       row.get("links", ""),
			})

	file.close()
	return matches


func _parse_md_row(line: String) -> Array:
	# Expects a line like: | cell1 | cell2 | cell3 |
	if not line.begins_with("|"):
		return []
	var parts := line.split("|")
	var cells := []
	# parts[0] is empty (before first |), parts[-1] may be empty (after last |)
	for i in range(1, parts.size() - 1):
		cells.append(parts[i].strip_edges())
	return cells

func _on_update_links_pressed(links_edit: TextEdit, result: Dictionary) -> void:
	var new_links := links_edit.text.strip_edges()
	var file := FileAccess.open(result["file"], FileAccess.READ)

	if file == null:
		push_error("Could not open file: " + result["file"])
		return

	var content := file.get_as_text()
	file.close()

	# Split links into individual [[tokens]] to validate format
	var tokens := new_links.split(",")
	var cleaned := []
	for token in tokens:
		var t := token.strip_edges()
		if not t.is_empty():
			# Wrap in [[ ]] if not already
			if not t.begins_with("[["):
				t = "[[" + t
			if not t.ends_with("]]"):
				t = t + "]]"
			cleaned.append(t)
	var final_links := ", ".join(cleaned)

	# Replace the links cell in the matching row
	var lines := content.split("\n")
	for i in range(lines.size()):
		var cells := _parse_md_row(lines[i])
		if cells.size() >= 1 and cells[0] == result["var_name"]:
			# Rebuild the row with the new links value
			cells[4] = final_links
			lines[i] = "| " + " | ".join(cells) + " |"
			break

	var out := FileAccess.open(result["file"], FileAccess.WRITE)
	if out == null:
		push_error("Could not write file: " + result["file"])
		return

	out.store_string("\n".join(lines))
	out.close()
	print("Links updated in: ", result["file"])