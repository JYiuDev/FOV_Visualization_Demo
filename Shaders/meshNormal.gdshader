shader_type canvas_item;

uniform vec4 non_mesh_color: source_color;
uniform vec4 fov_mesh_color: source_color;

//User: Camera node in the normal map viewport
//Goal: This script converts anything that isnt the same colour as the generated FOV mesh into another color(black)
//This is to generate a black and white normal map with the same dimensions as the screen to represent areas within or without the FOV
void fragment() {
	// Called for every pixel the material is visible on.
	vec4 current_color = texture(TEXTURE,UV);
	if(current_color != fov_mesh_color)
	{
		COLOR = non_mesh_color;
	}
}
