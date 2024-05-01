extends Node2D

var next_scene = null
var goal_counter = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	next_scene = get_meta("next_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkCollidingObject()
	_checkWinCondition()

func _checkCollidingObject():
	var area = get_node("Area")
	for body in area.get_overlapping_bodies():
		if body.name == "Player":
			goal_counter -= 1
			body.queue_free()
		elif body.name == "CursorCollider":
			goal_counter -= 1
			body.queue_free()
			
func _checkWinCondition():
	if goal_counter == 0:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
