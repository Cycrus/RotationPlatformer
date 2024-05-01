extends CharacterBody2D

# ----------------------------- Variables ---------------------------

const SPEED = 100
const SPEED_DAMPENING = 0.05
var curr_speed = SPEED
var motion = Vector2(0, 0)
var setup = true
var start_countdown = 10
var player = null
var kill_distance = 1200
var game_controller = null
		
# ----------------------------- Built-In Methods ---------------------------

# Sets the mouse parameters to correctly work.
func _ready():
	game_controller = get_parent().get_node("GameController")
	player = get_parent().get_node("Player")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Handles the association of the cursor collider with the mouse movement.
func _input(event):
	if start_countdown == 0:
		if event is InputEventMouseMotion:
			var mouse_motion = event.get_relative()
			motion = mouse_motion * curr_speed
	else:
		start_countdown -= 1
		
# Sets up the position to start close to the player character.
func _process(delta: float):
	if setup:
		var player = get_parent().get_node("Player")
		global_position = player.global_position
		global_position.y -= 50
		global_position.x += 30
		setup = false

# Handles the velocity of the cursor collider and checks if it collides with
# any TileMaps.
func _physics_process(delta: float):
	velocity = motion
	motion -= motion * SPEED_DAMPENING
	move_and_slide()
	_checkCollidingObject()
	_checkPlayerDistance()

# ----------------------------- Private Methods ---------------------------

# Checks if the cursor collider still collides with a world element after
# rotating it 10 degree negatively from the world element direction.
# Used to check if the cursor collider blocks a world elements rotation or not.
#
# param element: The world element to check the cursor collider with
func _checkRotatedOverlap(element: Node2D):
	var tile_map = element.getTileMap()
	var position = global_position
	var rotation_direction = -element.getRotationDirection()
	var rotated_position = element.locallyRotateForeignPoint(global_position, 10 * rotation_direction)
	var hits_tile = element.checkGlobalPositionForTile(rotated_position)
	return hits_tile
		
# Checks if the cursor collides with any tile maps in the current frame.
# Stops a world element which rotates towards the cursor collider.
# Also kills the cursor if it touches a dangerous element.
func _checkCollidingObject():
	var area = get_node("Area2D")
	for body in area.get_overlapping_bodies():
		if body is TileMap and body.name == "Tiles":
			if _checkRotatedOverlap(body.get_parent()):
				body.get_parent().stopRotation()
			if _isDangerous(body.get_parent()):
				_kill()
				
func _kill():
	queue_free()
	game_controller.looseGame()
	
func _isDangerous(element):
	return element.is_in_group("Danger")

func _checkPlayerDistance():
	if player != null:
		var distance_vector = player.global_position - global_position
		var distance = distance_vector.length()
		if distance >= kill_distance:
			_kill()
			
		var move_distance = kill_distance + kill_distance / 60
		curr_speed = (1 - distance / move_distance) * SPEED
