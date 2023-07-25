shader_type canvas_item;

uniform float my_number = 3.0;
uniform sampler2D my_info;

float is_inner_rects(float x, float y) {
	float left = step(0.1, x);
	float top = step(0.1, y); 
	float right = 1.0 - step(0.9, x);
	float bottom = 1.0 - step(0.9, y);
	
	float inner_rect = 1.0 - left * top * right * bottom;
	
	return inner_rect;
}

void fragment() {
	// Place fragment code here.
	
	vec2 uv = fract(UV * vec2(my_number));
	
	float inner_rect = is_inner_rects(uv.x, uv.y);
	
	vec2 ij = UV * vec2(my_number) - uv + 0.5;
	
	vec4 my_info_color = texture(my_info, ij/vec2(my_number));
	
	vec3 color = mix(my_info_color.rgb, vec3(1.0), inner_rect);
	
	COLOR = vec4(color, 1.0);
	
}