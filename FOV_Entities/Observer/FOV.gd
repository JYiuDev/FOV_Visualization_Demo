extends Node2D
class_name FOV

@export_category("FOV properties")
@export var viewRadius: float 
@export var viewAngle:  float

@export_range(0.01, 1) var findTargetFrequency: float = 0.5
@export_range(0.01, 1) var raycastResolution: float   = 0.01

var targetsInRange: 	Array = []
var targetsInVision:	Array = []

var FOVmesh: MeshInstance2D
var FOVDraw: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	FOVmesh = get_node("FOV_Mesh")
	FOVDraw = get_node("FOV_DebugDraw")
	FindTargets(findTargetFrequency)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
	
func _draw():
	#Draw red line to enemy in sight
	if targetsInVision.size() > 0:
		for target in targetsInVision:
			var degreeToTarget = get_angle_to(target.global_position)
			if (rad_to_deg(degreeToTarget) >= -viewAngle/2) and (rad_to_deg(degreeToTarget) <= viewAngle/2):
				var dirToTarget    = Vector2(cos(degreeToTarget), sin(degreeToTarget))
				var disToTarget    = global_position.distance_to(target.global_position)
				draw_line(position, dirToTarget * disToTarget, Color.RED)
	RaycastAarray()
	

func FindTargets(time:float):
	var physics = get_world_2d().direct_space_state
	var shapCastQuery:PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	var shape:CircleShape2D = CircleShape2D.new()
	shape.radius = viewRadius
	shapCastQuery.set_shape(shape)
	shapCastQuery.set_transform(global_transform)
	shapCastQuery.set_collision_mask(0b110)
	var result = physics.intersect_shape(shapCastQuery)
	targetsInRange.clear()
	targetsInRange = result
	targetsInVision.clear()
	
	for targets:Dictionary in targetsInRange:
		var target = targets["collider"]
		var origin: Vector2 = global_position
		var end: Vector2 = target.global_position
		var raycastQuery: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(origin,end,0b110,[self])
		var raycastResult = physics.intersect_ray(raycastQuery)
		if raycastResult["collider"].get_collision_layer_value(3):
			targetsInVision.append(raycastResult["collider"])
		#print(testVar.global_position)
	#print(targetsInRange)
	await get_tree().create_timer(time).timeout
	FindTargets(time)
			
func RaycastAarray():
	var rayNumber:int = roundi(viewAngle * raycastResolution)
	
	#Instantiate array of Vector2, the array size will be rayNumber + 2 (for the outer most lines)
	var rayArray: Array
	var step: float = viewAngle / (rayNumber + 1)
	#Array of vector2 positions(local POV) 
	var viewPoints: Array = []
	
	for i in (rayNumber + 2):
		#print("i is: " + str(i))
		#print("Current angle: " + str(i * step))
		var angle = i * step
		var viewcast:viewcastInfo = ViewCastInfo(angle)
		if viewcast.hit:
			draw_line(position, viewcast.point, Color.MEDIUM_VIOLET_RED)
			FOVDraw.draw_line(position, viewcast.point, Color.MEDIUM_VIOLET_RED)
		else:
			draw_line(position, viewcast.point, Color.BLACK)
			FOVDraw.draw_line(position, viewcast.point, Color.BLACK)
		viewPoints.append(viewcast.point)
	
	#Instantiate array for mesh verticies
	#Count = all raycasts + centre vertex
	var verticies:Array
	verticies.append(Vector2.ZERO) 
	verticies.append_array(viewPoints)
	#Number of triangles = verticies count - 2
	var triangles:PackedVector2Array
	triangles.resize((verticies.size() - 2) * 3)
	
	for i in triangles.size():
		match i%3:
			0:
				triangles[i] = Vector2.ZERO
			1:
				triangles[i] = verticies[i / 3 + 1]
			2:
				triangles[i] = verticies[i / 3 + 2]
	
	#Create new array mesh, pass to child mesh instance
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = triangles
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	FOVmesh.mesh = arr_mesh
	
	#debug draw
	for i in viewPoints.size():
		
		pass
	
	#Set triangle vertices for ArrayMesh
	
	
# Takes in angle and spits out local relative vector, UP is 0
func dirFromAngle(angleInDegree: float, global: bool) -> Vector2:
	if not global:
		angleInDegree += global_rotation_degrees

	var radians: float = (angleInDegree) * PI/180
	return Vector2(cos(radians), sin(radians))

#give angle, return viewcastinfo
func ViewCastInfo(angle_local: float) -> viewcastInfo:
	var ray_dir   = dirFromAngle((-viewAngle / 2) + angle_local, false)
	var local_dir = dirFromAngle((-viewAngle / 2) + angle_local, true)
	var physics = get_world_2d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_dir * viewRadius, 0b110, [self])
	var ray_result = physics.intersect_ray(rayQuery)
	
	if ray_result.is_empty():
		return viewcastInfo.new(false, local_dir * viewRadius, viewRadius, angle_local)
	else:
		return viewcastInfo.new(true, local_dir * global_position.distance_to(ray_result["position"]), global_position.distance_to(ray_result["position"]), angle_local)

#Subclass for RaycastInformation
class viewcastInfo :
	var hit		: bool
	var point	: Vector2
	var dist	: float
	var angle	: float
	
	func _init(_hit:bool, _point:Vector2, _dist: float, _angle: float):
		hit 	= _hit
		point 	= _point
		dist	= _dist
		angle	= _angle


#Archived Raycast Array code for emergency
#func RaycastAarray():
	#var rayNumber:int = roundi(viewAngle * raycastResolution)
	#
	##Instantiate array of Vector2, the array size will be rayNumber + 2 (for the outer most lines)
	#var rayArray: Array
	#var step: float = viewAngle / (rayNumber + 1)
#
	#for i in (rayNumber + 2):
		##print("i is: " + str(i))
		##print("Current angle: " + str(i * step))
		#var angle = i * step
		#var dir  = dirFromAngle((-viewAngle / 2) + angle, false)
		#var dir_global = dirFromAngle((-viewAngle / 2) + angle, true)
		#var physics = get_world_2d().direct_space_state
		#var rayQuery = PhysicsRayQueryParameters2D.create(global_position, global_position + dir * viewRadius, 0b110, [self])
		#var result = physics.intersect_ray(rayQuery)
		#if result.is_empty():
			#draw_line(position, dir_global * viewRadius, Color.HONEYDEW)
		#else:
			#draw_line(position, dir_global * global_position.distance_to(result["position"]), Color.ORANGE)
