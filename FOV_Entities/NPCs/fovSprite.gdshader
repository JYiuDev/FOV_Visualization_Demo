shader_type canvas_item;

uniform vec2 player_pos;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec3 pixel_world_pos = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
