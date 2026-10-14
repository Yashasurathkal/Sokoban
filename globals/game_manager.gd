extends Node


const LEVEL = preload("res://scenes/level/level.tscn")
const LEVEL_SELECTOR = preload("res://scenes/level_selector/level_selector.tscn")


var level_selected: String = "1"


func load_main() -> void:
	get_tree().change_scene_to_packed(LEVEL_SELECTOR)


func load_level(level_number: String) -> void:
	level_selected = level_number
	get_tree().change_scene_to_packed(LEVEL)
