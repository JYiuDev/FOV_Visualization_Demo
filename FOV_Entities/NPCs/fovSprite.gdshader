shader_type canvas_item;

uniform float viewDistance = 0;
uniform vec2 player_pos = vec2(0.69, 0.69);
varying vec2 world_pos;

void vertex() {
	// Called for every vertex the material is visible on.
	//Multiplying VERTEX to the inverse view matrix to get a pixel's world position
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	if(player_pos != vec2(0.69,0.69))
	{
		
	}
	if(!(distance(world_pos, player_pos) <= viewDistance))
	{
		color.a = 0.0;
	}
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
