shader_type canvas_item;

uniform vec4 non_mesh_color: source_color;
uniform vec4 fov_mesh_color: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 current_color = texture(TEXTURE,UV);
	if(current_color != fov_mesh_color)
	{
		current_color.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
