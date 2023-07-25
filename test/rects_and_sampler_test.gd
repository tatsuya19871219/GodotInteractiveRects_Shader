@tool

extends Sprite2D


var image_texture: ImageTexture
var image: Image

# Called when the node enters the scene tree for the first time.
func _ready():
	image = Image.create(3, 3, false, Image.FORMAT_RGBA8)
	
	image_texture = ImageTexture.create_from_image(image)
	
	material.set_shader_parameter("my_info", image_texture)
	
	#image.set_pixel(0, 0, Color.RED)
	
	image_texture.update(image)
	
	$Timer.start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass


func _on_timer_timeout():
	
	for i in range(0, 2):
		for j in range(0, 2):
			var pixel_color = image.get_pixel(i, j)
			var new_color = pixel_color * 0.8
			new_color.a = 1.0
			image.set_pixel(i, j, new_color)
	
	var x = randi_range(0, 2)
	var y = randi_range(0, 2)
	
	image.set_pixel(x, y, Color.RED);
	
	image_texture.update(image)
	pass # Replace with function body.
