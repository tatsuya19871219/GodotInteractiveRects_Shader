@tool

extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var mouse_position = get_local_mouse_position()
	var mouse_location = get_local_mouse_position() / texture.get_size()
	
	#print(mouse_position)
	
	material.set_shader_parameter("mouse_location", mouse_location);
	
	pass
