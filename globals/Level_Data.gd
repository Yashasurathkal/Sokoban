extends Node

const DATA_PATH: String = "res://data/level_data.json"

var _level_data: Dictionary[String, LevelLayout]

func get_level_data(level_number: String) -> LevelLayout:
	if !_level_data.has(level_number):
		push_error("Levl %s not found in _level_data" % level_number)
		return null
	return _level_data[level_number]

func get_level_names() -> Array[String]:
	return _level_data.keys()

func _enter_tree() -> void:
	load_level_data()

func load_level_data() -> void:
	var file_text: String = FileAccess.get_file_as_string(DATA_PATH)
	
	if file_text.is_empty():
		push_error("Did not find level data!!!")
		return
	var json_data: Dictionary = JSON.parse_string(file_text)
	for key in json_data:
		var layout:LevelLayout = LevelLayout.new()
		layout.parse(json_data[key])
		_level_data[key] = layout
		pass
