shader_type canvas_item;
uniform sampler2D tex;
uniform float time;

uniform vec3 col;
uniform float csb[5];

#define contrast csb[0]
#define saturation csb[1]
#define brightness csb[2]
#define pop_strength csb[3]
#define pop_threshold csb[4]

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(tex, UV);
	//vec3 gray = vec3(dot(color.rgb, vec3(.5, .5, .5)));
	float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	
	vec3 out_col = gray > 0.5 ? 1.0 - (1.0 - 2.0 * (color.xyz - 0.5)) * (1.0 - col) : 2.0 * color.xyz * col;
	out_col = mix(vec3(gray), out_col, saturation);
	out_col = (out_col - .5) * contrast + .5;
	out_col = out_col + pop_strength * max(gray - pop_threshold, 0.0);
	out_col = out_col + brightness;
	
	COLOR = vec4(out_col, 1.0);
	
	//COLOR = vec4(gray, 1.0 - time);
}

//void light() {
	//LIGHT = vec4(1.0, 1.0, 1.0, 0.0);
//}
