extends Node2D

var shader_nr = 0
var shade_element_lists = []
var shader = []

# Called when the node enters the scene tree for the first time.
func _ready():
	initLists()
	fetchShadeElements()
	loadInitShader()
	assignShaders()
	
func reassignShader(shader_file, id):
	loadShader(shader_file, id)
	assignShaders()
	
func initLists():
	shader_nr = get_meta("shader_files").size()
	for shader_id in range(shader_nr):
		shader.push_back(null)
		shade_element_lists.push_back([])

func loadShader(shader_file, id):
	var shader_path = "res://shader/" + shader_file + ".gdshader"
	shader[id] = load(shader_path)

func loadInitShader():
	for shader_id in range(shader_nr):
		loadShader(get_meta("shader_files")[shader_id], shader_id)
	
func fetchShadeElements():
	var scene = get_parent().get_parent()
	for shader_id in range(shader_nr):
		shade_element_lists[shader_id] = get_tree().get_nodes_in_group("ShadeGroup" + str(shader_id))
	
func assignShaders():
	for shader_id in range(shader_nr):
		var new_material = ShaderMaterial.new()
		new_material.shader = shader[shader_id]
		for element in shade_element_lists[shader_id]:
			var tiles_exist = element.get_node("Tiles") != null
			var sprite_exists = element.get_node("Sprite2D") != null
			var line_exists = element.get_node("Line2D") != null
			var background_exists = element.get_node("Background") != null
			if tiles_exist:
				element.get_node("Tiles").material = new_material
			if sprite_exists:
				element.get_node("Sprite2D").material = new_material
			if line_exists:
				element.get_node("Line2D").material = new_material
			if background_exists:
				element.get_node("Background").material = new_material
				
