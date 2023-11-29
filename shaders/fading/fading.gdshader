shader_type canvas_item;

uniform vec4 fading_color: source_color = vec4(0, 0, 0, 1);


void fragment() {
	COLOR = fading_color;
}
