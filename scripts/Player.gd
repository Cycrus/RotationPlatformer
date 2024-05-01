extends CharacterBody2D

# ----------------------------- Variables ---------------------------

const SPEED = 400.0
const RUN_FACTOR = 1.5
const JUMP_VELOCITY = -1300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var curr_speed = 0.0
var world_element_controller = null
var game_controller = null

# ----------------------------- Built-In Methods ---------------------------

func _ready():
	world_element_controller = get_node("WorldElementController")
	game_controller = get_parent().get_node("GameController")

# Handles all the Movement and user input.
func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()
		
	var direction = Input.get_axis("player_left", "player_right")
	
	if Input.is_action_pressed("player_run"):
		curr_speed = SPEED * RUN_FACTOR
	else:
		curr_speed = SPEED
	
	if direction:
		velocity.x = direction * curr_speed
	else:
		velocity.x = move_toward(velocity.x, 0, curr_speed)
		
	if global_position.y >= 1000:
		_kill()

	move_and_slide()
	_checkCollidingObject()
	
# ----------------------------- Private Methods ---------------------------

# Simply instructs the player object to jump up.
func _jump():
	velocity.y = JUMP_VELOCITY
	world_element_controller.rotateAllElements()
	
func _kill():
	queue_free()
	game_controller.looseGame()
	
func _checkCollidingObject():
	var area = get_node("Area2D")
	for body in area.get_overlapping_bodies():
		if body is TileMap and body.name == "Tiles":
			if _isDangerous(body.get_parent()):
				_kill()

func _isDangerous(element):
	return element.is_in_group("Danger")
