shader_type canvas_item;
//Normalmap texture that tells which areas are visible
uniform sampler2D mask_texture;


void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);
	if(mask.r < 0.7) {
		color.a = 0.0;
	}
	COLOR = color;
}