shader_type canvas_item;

// for circles
uniform float amplitude: hint_range(0, 5, 0.01) = 2.0;
uniform float frequency: hint_range(0, 15, 0.01) = 12.69;
uniform float rippleRate : hint_range(0.5, 150.0, 0.1) = 9.2;


// for wave
uniform float waveAmplitude = 0.1;
uniform float waveFrequency = 4.0;
uniform float blendingAmount = 0.6;

uniform int pixel_amount = 40;


// other
uniform sampler2D noise;

uniform float rotation_freq: hint_range(0.0, 32.0, 0.1) = 0.1;


vec2 wave(vec2 uv, float time) {
    return vec2(
        uv.x + sin(uv.y + 50.0 * time * waveFrequency) * waveAmplitude,
        uv.y + sin(uv.x + time * waveFrequency) * waveAmplitude
    );
}



void fragment() {
	// Rotation
	float theta = TIME;
	vec2 uv = UV;
	float norm = 12.0;
	
	vec2 v_theta = norm * vec2(-sin(theta * rotation_freq) * UV.x, cos(theta * rotation_freq) * UV.y);
	vec2 v_r = vec2(0, 0);
	
	uv.x += TIME * (v_r - v_theta).x;
	uv.y += TIME * (v_r + v_theta).y;
	
	vec2 wave_uv = wave(uv, TIME);
	vec2 grid_uv = round(uv * float(pixel_amount)) / float(pixel_amount);
	
	vec4 ns = texture(noise, grid_uv);
	
	vec2 motion = vec2(0.0, 1.0);
	float pi = 3.14159265358979323846;
	uv = UV * 2.0 - 1.0;

	float dist = length(uv);
	ns *= 1.4142135;
	dist += -0.1 * ns.x;
	float ripple = sin(dist * -frequency * pi + rippleRate * TIME) * amplitude / (dist + 1.0);


	vec4 color = vec4(0.341, 0, 0.098, 2.0 * ripple);
	
	float alphaScalar = (1.0 - min(dist, 1.0)) * ns.x * 2.5; 
	


	color.a *= 1.0 * alphaScalar * (ripple + ns.x * ns.y);
	color.a = max(color.a - (ns.y * 0.45), 0.0);
	
	// color = texture(TEXTURE, grid_uv);

    COLOR = color;
}