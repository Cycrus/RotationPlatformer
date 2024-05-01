extends Node2D

var menu_open = false
var menu_object = null
var time_label = null
var time = 0

var scene = null
var player = null
var cursor = null
var main_camera = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_setupMainCamera()
	menu_object = get_node("Ui").get_node("Menu")
	time_label = get_node("Ui").get_node("Time")
	
func _setupMainCamera():
	scene = get_parent()
	get_node("Camera2D").make_current()
	main_camera = get_node("Camera2D")
	
func _setMainCameraOrientation():
	player = scene.get_node("Player")
	cursor = scene.get_node("CursorCollider")
	if(player == null):
		cursor.get_node("Camera2D").make_current()
	elif(cursor == null):
		player.get_node("Camera2D").make_current()
	else:
		var player_pos = player.global_position
		var cursor_pos = cursor.global_position
		var distance = cursor_pos - player_pos
		var camera_pos = player_pos + distance * 0.0
		main_camera.global_position = camera_pos
		
		var zoom = main_camera.zoom
		zoom = distance / Vector2(get_viewport().size)
		zoom = abs(zoom)
		zoom.x = max(zoom.y, zoom.x)
		zoom.y = zoom.x
		zoom = Vector2(1.3, 1.3) - zoom
		if zoom.x > 1:
			zoom.x = 1
			zoom.y = 1
		elif zoom.x < 0.6:
			zoom.x = 0.6
			zoom.y = 0.6
		main_camera.zoom = zoom
	
func toggleMainMenu():
	menu_open = !menu_open
	if menu_open:
		menu_object.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		get_tree().paused = true
	else:
		get_tree().paused = false
		menu_object.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggleMainMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	_setTime(delta)
	_setMainCameraOrientation()
	
func _setTime(delta: float):
	if !menu_open:
		time += 1.4 * delta
		time_label.text = str(int(time))


func _on_continue_button_pressed():
	toggleMainMenu()


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
