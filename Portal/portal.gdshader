shader_type canvas_item;

// for circles
uniform float amplitude: hint_range(0, 5, 0.01) = 2.0;
uniform float frequency: hint_range(0, 15, 0.01) = 12.69;
uniform float rippleRate : hint_range(0.5, 150.0, 0.1) = 9.2;

uniform vec4 portal_color: source_color = vec4(0.341, 0, 0.098, 1);


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

// swirl
uniform float ratio : hint_range(0.0, 1.0) = 0.1;
 
uniform float power: hint_range(0.0, 5.0, 0.001) = 3.0;
 
uniform float min_speed = 10.0;
 
uniform float max_speed = 90.0;

void fragment() {
	// Rotation
	// float theta = TIME / rotation_freq;
	vec2 uv = UV * 2.0 - 1.0;  // Centre
	float norm = 12.0;
	float theta = atan(-uv.y + 0.5, uv.x - 0.5) ;;
	
	// Swirl
	float dist = length(uv);  // norm du vecteur position par rapport à (0, 0)
	float rspeed = mix(max_speed, min_speed, dist);
	float sinx = sin((1. - ratio) * rspeed);
    float cosx = cos((1. - ratio) * rspeed);
 
    vec2 trs = uv * mat2(vec2(cosx, sinx), vec2(-sinx, cosx));
    trs /= pow(ratio, power);
    
    trs += vec2(1.0);
    trs /= 1.;
	
	
	
	float v_theta = 2000.0;
	float v_r = 100.0;
	
	uv.x += (v_r * cos(theta) - v_theta * sin(theta));
	uv.y += (v_r * sin(theta) + v_theta * cos(theta));
	
	vec2 wave_uv = wave(trs, TIME);
	trs = round(trs * float(pixel_amount)) / float(pixel_amount);
	dist = round(dist * float(pixel_amount)) / float(pixel_amount);
	
	vec4 ns = texture(noise, trs);
	
	vec2 motion = vec2(0.0, 1.0);
	float pi = PI;
	
	dist += -0.21 * ns.x;

	
	float ripple = sin(dist * -frequency * PI + rippleRate * TIME) * amplitude / (dist + 1.0);
	
	


	vec4 color = vec4(portal_color.r, portal_color.g, portal_color.b, 1.0 * ripple);
	
	float alphaScalar = (1.0 - min(dist, 1.0)) * ns.x * 2.5; 
	


	color.a *= 1.0 * alphaScalar * (ripple + ns.x * ns.y);
	color.a = max(color.a - (ns.y * 0.45), 0.0);
	
	// color = texture(TEXTURE, grid_uv);

    
	COLOR = color;
}