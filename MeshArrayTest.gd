extends Node2D

func _ready():
	var verticies = PackedVector2Array()
	verticies.append(Vector2.ZERO)
	verticies.append(Vector2(0, 200))
	verticies.append(Vector2(200,200))
	verticies.append(Vector2.ZERO)
	verticies.append(Vector2(100,000))
	verticies.append(Vector2(100,100))
	
	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verticies
	
	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = MeshInstance2D.new()
	m.mesh = arr_mesh
	
	add_child(m)

