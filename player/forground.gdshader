shader_type canvas_item;

uniform vec4 color: source_color;
uniform sampler2D noise: repeat_enable;
uniform float flashState: hint_range(0, 1);

uniform float speed = 1.0;

void fragment() {
	vec2 uv = vec2(UV.x + TIME * speed, UV.y);
	vec4 noiseColor = texture(noise, uv);
	
	COLOR = mix(noiseColor, color, flashState);
	COLOR.a *= noiseColor.a;
}
