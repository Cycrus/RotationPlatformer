extends Node2D


# ----------------------------- Variables ---------------------------

var remaining_rotation = 0
var rotation_point = null
var tile_map = null
var rotation_speed = 0.0
var rotation_step = 0
var stop_rotation_counter = 0

# ----------------------------- Public Methods ---------------------------

func getTileMap():
	return tile_map

func getRotationPoint():
	return rotation_point
	
# Requests a rotation and initializes it if possible.
func requestRotation():
	var can_rotate = get_meta("can_rotate")
	if can_rotate and remaining_rotation == 0:
		initRotation(rotation_step)

# Inits a rotation motion to the tile map.
#
# param angle_degrees: The angle to rotate in degrees.
func initRotation(angle_degrees: float):
	remaining_rotation = angle_degrees
	
# Stops the rotation for 5 frames.
func stopRotation():
	stop_rotation_counter = 5
	
# Returns the rotation direction of the puzzle element.
#
# return: The rotation direction. 1: clockwise, -1: counter-clockwise
func getRotationDirection():
	return sign(rotation_step)
	
# Rotates any point around the rotation point of the puzzle element for a certain
# degree in a single motion. Useful for relative distance checks with hypothetical
# rotations.
#
# param point: The point to rotate.
# param angle_degrees: The angle to rotate the point in degrees.
# return: The rotated point.
func locallyRotateForeignPoint(point: Vector2, angle_degrees: float):
	var translated_point = point - rotation_point.global_position
	var rotated_translated_point = _rotate_point(translated_point, angle_degrees)
	var rotated_point = rotated_translated_point + rotation_point.global_position
	return rotated_point
	
# Checks a global position if it contains a tile of the TileMap.
#
# param position: The global position to check for.
# return: true if a tile is at the given position.
func checkGlobalPositionForTile(position: Vector2):
	var local_position = tile_map.to_local(position)
	var cell_position = tile_map.local_to_map(local_position)
	var cell_data = tile_map.get_cell_tile_data(0, cell_position)
	return cell_data != null
	
# ----------------------------- Built-In Methods ---------------------------

# Sets up the rotation data from the objects meta data.
func _ready():
	_getRotationComponents()
	rotation_speed = get_meta("rotation_speed")
	rotation_step = get_meta("rotation_step")
	
# Performs the rotation if necessary, and reduces the counter for a forced
# rotation stop.
func _physics_process(delta: float):
	if remaining_rotation != 0 and stop_rotation_counter == 0:
		_rotateElement(rotation_speed * delta * sign(remaining_rotation))
	if stop_rotation_counter > 0:
		stop_rotation_counter -= 1

# ----------------------------- Private Methods ---------------------------

# Rotates a point for a certain angle around the global origin.
#
# param point: The point to rotate.
# param angle_degrees: The angle in degrees to rotate.
# return: The rotated point.
func _rotate_point(point: Vector2, angle_degrees: float) -> Vector2:
	var radians = deg_to_rad(angle_degrees)
	var cos_angle = cos(radians)
	var sin_angle = sin(radians)
	var rotated_x = point.x * cos_angle - point.y * sin_angle
	var rotated_y = point.x * sin_angle + point.y * cos_angle
	return Vector2(rotated_x, rotated_y)
	
# Sets the rotation components tile_map and rotation_point.
# Does not return anything, just implicitly sets the member variables.
func _getRotationComponents():
	for child_id in range(get_child_count()):
		var child = get_child(child_id)
		if child is TileMap and child.name == "Tiles":
			tile_map = child
		elif child is Node2D and child.name == "RotationPoint":
			rotation_point = child
		if child != null and rotation_point != null:
			break
		
# Checks if a rotation is finished by checking it it is close enough to
# its finishing snap point and by checking if the remaining rotation angle
# is short enough. Used to snap the rotation.
#
# return: true if the rotation is finished.
func _isRotationFinished():
	var int_rotation = int(tile_map.rotation_degrees)
	var perfect_rotation_deviation = int_rotation % int(rotation_step)
	if perfect_rotation_deviation > (rotation_step / 2):
		perfect_rotation_deviation = rotation_step - perfect_rotation_deviation
		
	if perfect_rotation_deviation <= 5 and remaining_rotation <= 5 and remaining_rotation >= -5:
		return true
	return false
	
# Returns the closest snaped rotation point. Used to set the rotation if it is
# finished to a standardized angle.
#
# return: The closest snapping angle as a float.
func _getClosestSnappedRotation():
	var closest_snap = round(tile_map.rotation_degrees / rotation_step) * rotation_step
	return float(closest_snap)
	
# Actively performs the rotation for the TileMap element. Also checks if the
# rotation is finished and snaps the angle if it is.
#
# param angle_degrees: The degree to rotate in the current step.
func _rotateElement(angle_degrees: float):
	var rotation_position = global_position - rotation_point.global_position
	var angle_radians = deg_to_rad(angle_degrees)
	
	var t = Transform2D()
	t = t.translated(rotation_position)
	t = t.rotated(angle_radians)
	t = t.translated(-rotation_position)
	tile_map.transform *= t
	
	remaining_rotation -= angle_degrees
	if _isRotationFinished():
		remaining_rotation = 0
		tile_map.rotation_degrees = _getClosestSnappedRotation()
	
	
