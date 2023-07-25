@tool

extends Sprite2D

var rotating_angle = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	rotating_angle += PI/4 * delta
	
	material.set_shader_parameter("rotating_angle", rotating_angle)
	
	pass
