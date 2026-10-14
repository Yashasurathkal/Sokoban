extends Button




func _on_pressed() -> void:
	GameManager.load_level(text)
