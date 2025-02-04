shader_type canvas_item;
uniform sampler2D tex;
uniform float time;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(tex, UV);
	float alpha = 1.0;
	vec3 gray = vec3(dot(color.rgb, vec3(.5, .5, .5)));
	COLOR = vec4(gray, 1.0 - time);
}

//void light() {
	//LIGHT = vec4(1.0, 1.0, 1.0, 0.0);
//}
