shader_type canvas_item;

uniform vec2 mouse_location;

void fragment() {
	// Place fragment code here.
	
	if (abs(UV.x - mouse_location.x) < 0.01 || abs(UV.y - mouse_location.y) < 0.01) {
		COLOR = vec4(1.0);
	}
}
