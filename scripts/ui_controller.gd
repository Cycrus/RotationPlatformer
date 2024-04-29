extends Node2D

var menu_open = false
var menu_object = null
var time_label = null
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_object = get_node("Ui").get_node("Menu")
	time_label = get_node("Ui").get_node("Time")
	
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
	
func _setTime(delta: float):
	if !menu_open:
		time += 1.4 * delta
		time_label.text = str(int(time))


func _on_continue_button_pressed():
	toggleMainMenu()


func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
