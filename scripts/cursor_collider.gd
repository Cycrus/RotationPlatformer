extends CharacterBody2D

# ----------------------------- Variables ---------------------------

const SPEED = 100
const SPEED_DAMPENING = 0.08
var motion = Vector2(0, 0)
		
# ----------------------------- Built-In Methods ---------------------------

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		var mouse_motion = event.get_relative()
		motion = mouse_motion * SPEED

# Handles the movement of the cursor collider and checks if it collides with
# any TileMaps.
func _physics_process(delta: float):
	velocity = motion
	motion -= motion * SPEED_DAMPENING
	move_and_slide()
	_checkCollidingObject()

# ----------------------------- Private Methods ---------------------------

# Checks if the cursor collider still collides with a puzzle element after
# rotating it 10 degree negatively from the puzzle element direction.
# Used to check if the cursor collider blocks a puzzle elements rotation or not.
#
# param element: The puzzle element to check the cursor collider with
func _checkRotatedOverlap(element: Node2D):
	var tile_map = element.getTileMap()
	var position = global_position
	var rotation_direction = -element.getRotationDirection()
	var rotated_position = element.locallyRotateForeignPoint(global_position, 10 * rotation_direction)
	var hits_tile = element.checkGlobalPositionForTile(rotated_position)
	return hits_tile
		
# Checks if the cursor collides with any tile maps in the current frame.
# Stops a puzzle element which rotates towards the cursor collider.
func _checkCollidingObject():
	var area = get_child(1)
	for body in area.get_overlapping_bodies():
		if body is TileMap and body.name == "Tiles":
			if _checkRotatedOverlap(body.get_parent()):
				body.get_parent().stopRotation()
