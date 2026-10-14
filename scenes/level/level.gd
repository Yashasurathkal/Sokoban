extends Node


const SOURCE_ID: int = 0
const NO_SOURCE_ID: int = -1

const ATLAS_COORDS: Dictionary[LevelLayout.LayerType, Vector2i] = {
	LevelLayout.LayerType.Floor: Vector2i(4,0),
	LevelLayout.LayerType.Wall: Vector2i(0,0),
	LevelLayout.LayerType.Target: Vector2i(3,0),
	LevelLayout.LayerType.TargetBox: Vector2i(2,0),
	LevelLayout.LayerType.Box: Vector2i(1,0)
	}
@onready var player: AnimatedSprite2D = $Player
@onready var floors: TileMapLayer = $TileLayers/Floors
@onready var walls: TileMapLayer = $TileLayers/Walls
@onready var targets: TileMapLayer = $TileLayers/Targets
@onready var boxes: TileMapLayer = $TileLayers/Boxes
@onready var tile_layers: Node2D = $TileLayers
@onready var game_ui: GameUI = $GameUi







var _player_tile: Vector2i = Vector2i.ZERO
var _game_over: bool = false

func get_input_directon() -> Vector2i:
	var move_direction: Vector2i = Vector2i.ZERO
	
	if _game_over: return move_direction
	
	if Input.is_action_just_pressed("ui_right"):
		move_direction = Vector2i.RIGHT
		player.play("right")
	
	elif Input.is_action_just_pressed("ui_left"):
		move_direction = Vector2i.LEFT
		player.play("left")
	
	elif Input.is_action_just_pressed("ui_down"):
		move_direction = Vector2i.DOWN
		player.play("down")
	
	elif Input.is_action_just_pressed("ui_up"):
		move_direction = Vector2i.UP
		player.play("up")
	
	return move_direction



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.load_main()
	elif event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	else:
		move_player(get_input_directon())


func _ready() -> void:
	setup_level()

func check_game_state() -> void:
	for t in targets.get_used_cells():
		if not cell_is_box(t): return
	_game_over = true
	game_ui.game_over()

func cell_is_wall(cell: Vector2i) -> bool:
	return walls.get_cell_source_id(cell) != NO_SOURCE_ID

func cell_is_box(cell: Vector2i) -> bool:
	return boxes.get_cell_source_id(cell) != NO_SOURCE_ID

func cell_is_empty(cell: Vector2i) -> bool:
	return !cell_is_wall(cell) and !cell_is_box(cell)


func box_can_move(box_cell: Vector2i, direction: Vector2i) -> bool:
	return cell_is_empty(box_cell + direction)


func move_box(box_cell: Vector2i, direction: Vector2i) -> void:
	var dest: Vector2i = box_cell + direction
	boxes.erase_cell(box_cell)
	var layer_type: LevelLayout.LayerType = LevelLayout.LayerType.Box
	if dest in targets.get_used_cells(): layer_type = LevelLayout.LayerType.TargetBox
	
	boxes.set_cell(dest, SOURCE_ID , ATLAS_COORDS[layer_type])

func move_player(direction: Vector2i) -> void:
	if direction == Vector2i.ZERO: return
	var dest: Vector2i = _player_tile + direction
	if cell_is_wall(dest): return
	if cell_is_box(dest) and !box_can_move(dest, direction): return
	if cell_is_box(dest): move_box(dest,direction)
	place_player_on_tile(dest)
	game_ui.add_move()
	check_game_state()

func clear_all_tiles() -> void:
	for tl in tile_layers.get_children():
		if tl is TileMapLayer: tl.clear()

func setup_layer(layer_type: LevelLayout.LayerType, map_layer: TileMapLayer, layout: LevelLayout) -> void:
	for tc in layout.get_tiles_for_layer(layer_type):
		map_layer.set_cell(tc, SOURCE_ID, ATLAS_COORDS[layer_type])

func center_map() -> void:
	var map_middle: Vector2i = floors.get_used_rect().get_center()
	var map_middle_px: Vector2 = floors.to_global(floors.map_to_local(map_middle))
	tile_layers.position = floors.get_viewport_rect().get_center() - map_middle_px

func place_player_on_tile(dest: Vector2i) -> void:
	player.global_position = floors.to_global(floors.map_to_local(dest))
	_player_tile = dest


func setup_level() -> void:
	clear_all_tiles()
	var level_layout: LevelLayout = LevelData.get_level_data(GameManager.level_selected)
	setup_layer(LevelLayout.LayerType.Floor, floors , level_layout)
	setup_layer(LevelLayout.LayerType.Wall, walls , level_layout)
	setup_layer(LevelLayout.LayerType.Target, targets , level_layout)
	setup_layer(LevelLayout.LayerType.TargetBox, boxes , level_layout)
	setup_layer(LevelLayout.LayerType.Box, boxes , level_layout)
	center_map()
	place_player_on_tile(level_layout.player_start)
