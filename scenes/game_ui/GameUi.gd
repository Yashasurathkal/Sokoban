class_name GameUI
extends Control

@onready var moves_label: Label = $MC/HB2/MovesLabel
@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var best_label: Label = $MC/HB3/BestLabel
@onready var level_label: Label = $MC/HB/LevelLabel


var _moves_made: int = 0
func _ready() -> void:
	best_label.text = ScoreSync.get_level_best_str(GameManager.level_selected)
	level_label.text = GameManager.level_selected
func add_move() -> void:
	_moves_made += 1
	moves_label.text = "%03d" % _moves_made

func game_over() -> void:
	game_over_panel.show()
	ScoreSync.level_completed(GameManager.level_selected, _moves_made)
