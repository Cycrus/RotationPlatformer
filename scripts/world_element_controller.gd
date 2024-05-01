extends Node2D

var setup = true
var world_element_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if setup:
		setupController()
		setup = false
		
func setupController():
	var scene = get_parent().get_parent()
	world_element_list = get_tree().get_nodes_in_group("WorldElement")
		
func rotateAllElements():
	for element in world_element_list:
		element.requestRotation()
