shader_type canvas_item;
//Normalmap texture that tells which areas are visible
uniform sampler2D mask_texture;
const float darken_coe = 0.9;

//User: Player viewport container
//Function: Parse the normal map texture and process pixels that are marked as visible or invisible differently

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 mask = texture(mask_texture, UV);
	if(mask.r < 0.7) {
		//color.a = 0.0;
		color.r = color.r * darken_coe;
		color.g = color.g * darken_coe;
		color.b = color.b * darken_coe;
	}
	COLOR = color;
}