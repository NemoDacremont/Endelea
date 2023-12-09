shader_type canvas_item;

uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	
	if (COLOR.a != 0.0) {
		COLOR.a = alpha;
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
