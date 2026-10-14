extends Node


const DATA_PATH: String = "user://sokoban.json"
const DEFAULT_SCORE: int = 999999


var level_scores: Dictionary

func _enter_tree() -> void:
	load_scores()

func get_level_best_str(level_number: String) -> String:
	var b: int = get_level_best(level_number)
	return "-" if b == DEFAULT_SCORE else str(b)
	


func get_level_best(level_number: String) -> int:
	return level_scores.get(level_number, DEFAULT_SCORE)


func level_completed(level_number: String, score: int) -> void:
	if get_level_best(level_number) > score:
		level_scores[level_number] = score
		save_scores()
func load_scores() -> void:
	
	var file_text: String = FileAccess.get_file_as_string(DATA_PATH)
	
	if file_text.is_empty():
		push_error("Did not find lany scores!!")
		return
	level_scores = JSON.parse_string(file_text)


func save_scores() -> void:
	var file: FileAccess = FileAccess.open(DATA_PATH, FileAccess.WRITE)
	if file == null:
		printerr("Failed to save scores, no file")
	file.store_string(JSON.stringify(level_scores))
