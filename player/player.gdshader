shader_type canvas_item;

uniform float scale : hint_range(0.1, 10) = 2.0;
uniform vec4 color: source_color = vec4(0, 0, 0, 255);
uniform float flashState: hint_range(0, 1) = 0.5;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment() {
	// Place fragment code here.
	vec4  pixelColor = texture(TEXTURE, UV * scale);
	vec4 screenColor = texture(SCREEN_TEXTURE, UV);

	COLOR = mix(pixelColor, color, flashState);
	COLOR.a *= pixelColor.a;
}
