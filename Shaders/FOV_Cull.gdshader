shader_type canvas_item;
//Normalmap texture that tells which areas are visible
uniform sampler2D mask_texture;

//User: Player viewport container
//Function: Parse the normal map texture and process pixels that are marked as visible or invisible differently

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);
	if(mask.r < 0.7) {
		color.a = 0.0;
	}
	COLOR = color;
}