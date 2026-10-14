extends Control



const LEVEL_BUTTON = preload("res://scenes/LevelButton/LevelButton.tscn")
@onready var grid_container: GridContainer = $MC/VB/GridContainer





func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_level("1")


func _ready() -> void:
	for level in LevelData.get_level_names():
		var nb: Button = LEVEL_BUTTON.instantiate()
		nb.text = level
		grid_container.add_child(nb)
