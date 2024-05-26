extends Node2D
class_name FOV

@export_category("FOV properties")
@export var viewRadius: float 
@export var viewAngle:  float

@export_range(0.01, 1) var findTargetFrequency: float = 0.5
@export_range(0.01, 1) var raycastResolution: float   = 0.01

@export_range(0,20) var edgeFindIteration: int = 6

var targetsInRange: 	Array = []
var targetsInVision:	Array = []

var FOVmesh: MeshInstance2D
var FOVDraw: FOVDebug

@export_range(0, 50) var edgeThreshhold: float

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
	var viewPoints: PackedVector2Array = []
	var viewcastArray: Array = []
	var oldViewCast: ViewcastInfo
	
	for i in (rayNumber + 2):
		var angle = i * step
		var viewcast:ViewcastInfo = Viewcast(angle)
		
		if i > 0:
			var distance: float = abs(viewcast.dist - oldViewCast.dist)
			if((oldViewCast.hit != viewcast.hit) or (oldViewCast.hit and viewcast.hit and distance > edgeThreshhold)):
				var edge: EdgeInfo = FindEdge(oldViewCast, viewcast)
				if edge.pointA != Vector2.ZERO:
					viewPoints.append(edge.pointA)
				if edge.pointB != Vector2.ZERO:
					viewPoints.append(edge.pointB)
					
		viewPoints.append(viewcast.point)
		viewcastArray.append(viewcast)
		oldViewCast = viewcast
		
		
	#Pass viewpoints to debug
	FOVDraw.viewcastArray.clear()
	FOVDraw.viewcastArray = viewcastArray
	
	#Instantiate array for mesh verticies
	#Count = all raycasts + centre vertex
	var verticies:PackedVector2Array
	verticies.append(Vector2.ZERO) 
	verticies.append_array(viewPoints)
	#Number of triangles = verticies count - 2
	var triangles:PackedVector2Array
	triangles.resize((verticies.size() - 2) * 3)
	
	#Set array style triangles
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
	
	#Set triangle vertices for ArrayMesh
	

func FindEdge(minViewcast: ViewcastInfo, maxViewcast:ViewcastInfo) -> EdgeInfo:
	var minAngle = minViewcast.angle
	var maxAngle = maxViewcast.angle
	var minPoint = Vector2.ZERO
	var maxPoint = Vector2.ZERO
	
	#Iterate find edge algorithm 
	for i in edgeFindIteration:
		var angle	 	= (minAngle+maxAngle)/2.0
		var newViewCast = Viewcast(angle)
		var dist		= abs(newViewCast.dist - minViewcast.dist)
		var exceedThreshold:bool	= dist > edgeThreshhold
		#re-adjust min/max angle for next iteration
		if (newViewCast.hit == minViewcast.hit and !exceedThreshold):
			minAngle = angle
			minPoint = newViewCast.point
		else:
			maxAngle = angle
			maxPoint = newViewCast.point
	#output minpoint and max point
	return EdgeInfo.new(minPoint, maxPoint)
	
	
	

# Takes in angle and spits out local relative vector, UP is 0
func dirFromAngle(angleInDegree: float, global: bool) -> Vector2:
	if not global:
		angleInDegree += global_rotation_degrees

	var radians: float = (angleInDegree) * PI/180
	return Vector2(cos(radians), sin(radians))

#give angle, return viewcastinfo
func Viewcast(angle_local: float) -> ViewcastInfo:
	var ray_dir   = dirFromAngle((-viewAngle / 2) + angle_local, false)
	var local_dir = dirFromAngle((-viewAngle / 2) + angle_local, true)
	var physics = get_world_2d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters2D.create(global_position, global_position + ray_dir * viewRadius, 0b110, [self])
	var ray_result = physics.intersect_ray(rayQuery)
	
	if ray_result.is_empty():
		return ViewcastInfo.new(false, local_dir * viewRadius, viewRadius, angle_local)
	else:
		return ViewcastInfo.new(true, local_dir * global_position.distance_to(ray_result["position"]), global_position.distance_to(ray_result["position"]), angle_local)

#Subclass for RaycastInformation
class ViewcastInfo:
	var hit		: bool
	var point	: Vector2
	var dist	: float
	var angle	: float
	
	func _init(_hit:bool, _point:Vector2, _dist: float, _angle: float):
		hit 	= _hit
		point 	= _point
		dist	= _dist
		angle	= _angle

#Subclass for edge information
class EdgeInfo:
	var pointA	: Vector2
	var pointB	: Vector2
	
	func _init(_pointA:Vector2, _pointB:Vector2):
		pointA = _pointA
		pointB = _pointB

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
