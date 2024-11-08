shader_type canvas_item;

uniform sampler2D mask_texture;  //FOV texture
varying vec2 viewspace_pos;

void vertex() {
	// Called for every vertex the material is visible on.
	//viewspace_pos = (CANVAS_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 mask = texture(mask_texture, SCREEN_UV);
	vec4 color = texture(TEXTURE, UV);
	if(mask.r < 0.7) {
		color.a = 0.0;
	}
	COLOR = color;
}

