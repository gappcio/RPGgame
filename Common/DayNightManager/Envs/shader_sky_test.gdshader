shader_type sky;

uniform vec3 skyColor : source_color;
uniform vec3 horColor : source_color;
uniform float horBlend;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void sky() {
	float color = clamp(EYEDIR.y / horBlend, 0.0, 1.0);
	vec3 finalColor = mix(horColor, skyColor, color);
	COLOR = finalColor;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
