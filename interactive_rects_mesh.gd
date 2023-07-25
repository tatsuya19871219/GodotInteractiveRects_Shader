@tool

extends MeshInstance2D

@export var columns = 5
@export var rows = 7
@export var rect_size = 80.0
@export var rect_interval = 20.0

var rotation_info_texture: ImageTexture
var rotation_info: Image

@onready var mesh_size = mesh.size

var offset_normalized: Vector2
var rect_size_normalized: Vector2
var rect_interval_normalized: Vector2

var rotation_speed = 2*PI

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#var mesh_size = mesh.size
	material.set_shader_parameter("pixel_size", Vector2(1.0, 1.0) / mesh_size)
	
	var offset_x = (mesh_size.x - columns * (rect_size + rect_interval)) / 2.0
	var offset_y = (mesh_size.y - rows * (rect_size + rect_interval)) / 2.0
	
	offset_normalized = Vector2(offset_x, offset_y) / mesh_size
	rect_size_normalized = Vector2(rect_size, rect_size) / mesh_size
	rect_interval_normalized = Vector2(rect_interval, rect_interval) / mesh_size
	
	material.set_shader_parameter("offset", offset_normalized)
	
	material.set_shader_parameter("rects", Vector2i(columns, rows))
	material.set_shader_parameter("rect_size", rect_size_normalized)
	material.set_shader_parameter("rect_interval", rect_interval_normalized)
	
	rotation_info = Image.create(columns, rows, false, Image.FORMAT_RGB8)
	
#	for i in range(columns):
#		for j in range(rows):
#			var pixel = rotation_info.get_pixel(i, j);
#			rotation_info.set_pixel(i, j, Color((PI/4 + PI)/(2*PI), 0.0, 0.0))
	
	rotation_info_texture = ImageTexture.create_from_image(rotation_info)
	
	material.set_shader_parameter("rotation_info", rotation_info_texture)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if rotation_info == null: return
	
	var mouse_position = get_global_mouse_position()
	var mouse_velocity = Input.get_last_mouse_velocity()
	
	var mouse_velocity_flip = mouse_velocity
	mouse_velocity_flip.y = - mouse_velocity.y
	
	var mouse_velocity_normalized = mouse_velocity_flip / mesh_size
	
	#var mouse_location = mouse_position / Vector2(mesh.size.x, mesh.size.y)
	var mouse_location = mouse_position / mesh_size
	var mouse_location_flip = mouse_location
	mouse_location_flip.y = 1-mouse_location.y
	
	#print(mouse_position)
	#print(mouse_location)
	
	material.set_shader_parameter("mouse_location", mouse_location_flip)
	
	
	# update
	for i in range(columns):
		for j in range(rows):
			
			# Each pixel in rotation_info contains
			# r for rotation angle
			# g for rotation direction
			# b for nothing
			var pixel = rotation_info.get_pixel(i, j)
			
			# check if rotation is finished
			if (pixel.g == 0.0 and abs(pixel.r - 1.0) < 0.01) or (pixel.g == 1.0 and abs(pixel.r - 0.0) < 0.01): 
				pixel.r = 0.0
				pixel.g = 0.0
			
			if pixel.r > 0.0:
				var rect_rotation = float(pixel.r) * TAU - PI
		
				if pixel.g == 0.0:
					rect_rotation += rotation_speed*delta 
				else:
					rect_rotation -= rotation_speed*delta
					
				var rotation_normalized = (rect_rotation + PI) / TAU
				
				if rotation_normalized > 1.0: rotation_normalized -= 1.0
				if rotation_normalized < 0.0: rotation_normalized = 1.0 - rotation_normalized
				
				pixel.r = rotation_normalized
			
			rotation_info.set_pixel(i, j, pixel)
	
	# check touch location
	var rects_coord = mouse_location_flip - offset_normalized
	var rects_grid_coord = rects_coord / (rect_size_normalized + rect_interval_normalized)
	
	var rect_index = floor(rects_grid_coord)
	
	$CurrentRect.visible = false
	
	# 
	if (rect_index.x >= 0 and rect_index.y >= 0 and rect_index.x < columns and rect_index.y < rows):
		
		$CurrentRect/Label.text = "(%d, %d)" % [rect_index.x, rect_index.y]
		
		$CurrentRect.position = (offset_normalized + (rect_index+Vector2(0.5, 0.5)) * (rect_size_normalized + rect_interval_normalized)) * mesh_size
		#$CurrentRect.position = (offset_normalized + (rect_index) * (rect_size_normalized + rect_interval_normalized)) * mesh_size
		#$CurrentRect.position = (offset_normalized + rects_coord) * mesh_size
		$CurrentRect.position.y = mesh_size.y - $CurrentRect.position.y
		#$CurrentRect.visible = true
		
		#print(rect_index)
		#print((rect_size_normalized + rect_interval_normalized)*mesh_size)
		
		var inrect_coord = rects_grid_coord - rect_index
		
		var pixel = rotation_info.get_pixel(rect_index.x, rect_index.y)
	
		var inrect_center = Vector2(0.5, 0.5)
		
		var rect_rotation = float(pixel.r) * TAU - PI
		
		# calculate the direction of rotation
		var distance = inrect_coord - inrect_center

		var transition = distance + mouse_velocity_normalized
		
		#print(distance, transition)

		var direction = sign(Vector3(distance.x, distance.y, 0).cross(Vector3(transition.x, transition.y, 0)).z)
		
		#print(direction)

		if direction == sign(-1):
			direction = 0
			rect_rotation += rotation_speed*delta # if speed is too slow, the value in shader will be truncated (i.e., rect doesn't rotate)
		elif direction == sign(1):
			rect_rotation -= rotation_speed*delta
		#print(rect_rotation)
		
		var rotation_normalized = (rect_rotation + PI) / TAU
		
		if rotation_normalized > 1.0: rotation_normalized -= 1.0
		if rotation_normalized < 0.0: rotation_normalized = 1.0 - rotation_normalized
		
		rotation_info.set_pixelv(rect_index, Color(rotation_normalized, direction, 0.0))
	pass

	rotation_info_texture.update(rotation_info)
	
	$Cursor.position = mouse_position

