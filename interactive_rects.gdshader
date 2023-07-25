shader_type canvas_item;

uniform vec2 pixel_size;

uniform vec2 mouse_location;

uniform ivec2 rects;
uniform vec2 rect_size;
uniform vec2 rect_interval;

uniform vec2 offset;
uniform sampler2D rotation_info;

const float bg_intensity = 0.1;

float is_inner_rects(float x, float y, vec2 margin) {
	
	float left = step(margin.x, x);
	float top = step(margin.y, y); 
	float right = 1.0 - step(1.0-margin.x, x);
	float bottom = 1.0 - step(1.0-margin.y, y);
	
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
	
	if (UV.x < offset.x || UV.y < offset.y) {
		COLOR = vec4(vec3(bg_intensity), 1.0);
	}
	else if (1.0-UV.x < offset.x || 1.0 - UV.y < offset.y) {
		COLOR = vec4(vec3(bg_intensity), 1.0);
	}
	else {
		vec2 uv = fract((UV - offset) / (1.0 - 2.0*offset) * vec2(rects));
	
		// rotation
		vec2 ij = (UV - offset) / (1.0 - 2.0*offset) * vec2(rects) - uv + 0.5;
	
		vec4 rotation_info_color = texture(rotation_info, ij/vec2(rects));
	
		float rotation = rotation_info_color.r * TAU - PI;
		
		vec2 st = rotate(uv, rotation);
		
		vec2 margin = rect_interval/vec2(2.0)*vec2(rects);
		
		float inner_rect = is_inner_rects(st.x, st.y, margin);
		
		
		vec3 color = mix(vec3(0.0, 1.0, 1.0), vec3(bg_intensity), inner_rect);
		//vec3 color = mix(vec3(0.0, 1.0, 1.0), vec3(1.0), inner_rect);
		
		COLOR = vec4(color, 1.0);
	
		// display boundary of rects for debug
//		if (uv.x < margin.x/2.0 || uv.y < margin.y/2.0) {
//			COLOR = vec4(vec3(1.0, 0.0, 0.0), 1.0);
//		}
//
//		if (uv.x > 1.0-margin.x/2.0 || uv.y > 1.0-margin.y/2.0) {
//			COLOR = vec4(vec3(1.0, 0.0, 0.0), 1.0);
//		}
		
		//COLOR = vec4(vec3(uv, 0.0), 1.0);
	
		//COLOR = vec4(mouse_location, 0.0, 1.0);
	}
	
	// draw cross-hair
	if (abs(UV.x - mouse_location.x) < pixel_size.x || abs(UV.y - mouse_location.y) < pixel_size.y) {
		//COLOR = vec4(1.0);
		COLOR = mix(COLOR, vec4(vec3(1.0), 1.0), 0.5);
	}
	
	// display offset boundary for debug
//	if (abs(UV.x - offset.x) < pixel_size.x || abs(UV.y - offset.y) < pixel_size.y) {
//		COLOR = vec4(0.0);
//	}
//
//	if (abs(UV.x - (1.0 - offset.x)) < pixel_size.x || abs(UV.y - (1.0 - offset.y)) < pixel_size.y) {
//		COLOR = vec4(0.0);
//	}
}