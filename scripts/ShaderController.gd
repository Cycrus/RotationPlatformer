extends Node2D

var shader_nr = 3
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
	for shader_id in range(shader_nr):
		shader.push_back(null)
		shade_element_lists.push_back([])

func loadShader(shader_file, id):
	var shader_path = "res://shader/" + shader_file + ".gdshader"
	shader[id] = load(shader_path)

func loadInitShader():
	for shader_id in range(shader_nr):
		loadShader(get_meta("shader_file_" + str(shader_id + 1)), shader_id)
	
func fetchShadeElements():
	var scene = get_parent().get_parent()
	for shader_id in range(shader_nr):
		shade_element_lists[shader_id] = get_tree().get_nodes_in_group("ShadeGroup" + str(shader_id + 1))
	
func assignShaders():
	for shader_id in range(shader_nr):
		var new_material = ShaderMaterial.new()
		new_material.shader = shader[shader_id]
		for element in shade_element_lists[shader_id]:
			element.get_node("Tiles").material = new_material
