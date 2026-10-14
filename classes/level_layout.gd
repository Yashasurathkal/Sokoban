class_name LevelLayout
extends RefCounted

enum LayerType { Floor, Wall, Target, Box, TargetBox}


const JSON_MAP: Dictionary[LayerType, String] = {
	LayerType.Floor: "floor",
	LayerType.Wall: "wall",
	LayerType.Target: "target",
	LayerType.Box: "box",
	LayerType.TargetBox: "target_box",
}

var player_start: Vector2i = Vector2i.ZERO

var _tiles: Dictionary

func get_tiles_for_layer(lt : LayerType) -> Array[Vector2i]:
	return _tiles.get(lt, [])


func parse(data:Dictionary) -> void:
	var ps: Dictionary = data.player_start
	player_start = Vector2i(ps.x,ps.y)
	var tiles: Dictionary = data.tiles
	for layer in JSON_MAP.keys():
		var coords: Array[Vector2i] = []
		for coord in tiles[JSON_MAP[layer]]:
			coords.append(Vector2i(coord.x, coord.y))
		_tiles[layer] = coords
		pass
