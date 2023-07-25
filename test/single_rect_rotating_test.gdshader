shader_type canvas_item;

uniform float rotating_angle;

float is_inner_rects(float x, float y) {
	float left = step(0.1, x);
	float top = step(0.1, y); 
	float right = 1.0 - step(0.9, x);
	float bottom = 1.0 - step(0.9, y);
	
	float inner_rect = 1.0 - left * top * right * bottom;
	
	return inner_rect;
}

vec2 rotate(vec2 uv, float angle)
{
	mat2 rotation = mat2(vec2(cos(angle), -sin(angle)),
						vec2(sin(angle), cos(angle)));
	uv -= 0.5;
	uv = uv * rotation;
	uv += 0.5;
	return uv;
}

void fragment() {
	// Place fragment code here.
	vec3 color = vec3(0.0, 1.0, 1.0);
	
	vec2 st = rotate(UV, rotating_angle);
	
	float inner_rect = is_inner_rects(st.x, st.y);
	
	//color = vec3(left * top * right * bottom);
	color = mix(color, vec3(1.0, 1.0, 1.0), inner_rect);
	
	COLOR = vec4(color, 1.0);
}
