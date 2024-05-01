extends Node2D

func winGame():
	_switchScene(get_meta("win_scene"))
	
func looseGame():
	_switchScene(get_meta("loose_scene"))

func _switchScene(scene):
	if scene == "current":
		get_tree().reload_current_scene()
	else:
		var scene_path = "res://scenes/" + scene + ".tscn"
		get_tree().change_scene_to_file(scene_path)
