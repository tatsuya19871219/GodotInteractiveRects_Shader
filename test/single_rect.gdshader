shader_type canvas_item;

void fragment() {
	// Place fragment code here.
	vec3 color = vec3(0.0, 1.0, 1.0);
	
	float left = step(0.1, UV.x);
	float top = step(0.1, UV.y); 
	float right = 1.0 - step(0.9, UV.x);
	float bottom = 1.0 - step(0.9, UV.y);
	
	float inner_rect = 1.0 - left * top * right * bottom;
	
	//color = vec3(left * top * right * bottom);
	color = mix(color, vec3(1.0, 1.0, 1.0), inner_rect);
	
	COLOR = vec4(color, 1.0);
}
