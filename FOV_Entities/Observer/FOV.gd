extends Node2D
class_name FOV

@export_category("FOV properties")
@export var viewRadius: float 
@export var viewAngle:  float

@export_range(0.01, 1) var findTargetFrequency: float = 0.5
@export_range(0.01, 1) var raycastResolution: float   = 0.01
var targetsInRange: 	Array = []
var targetsInVision:	Array = []

var viewcastInfo_mold:  Dictionary = {
	"origin" : Vector2.ZERO,
	"end"    : Vector2.ZERO,
	"position": Vector2.ZERO,
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	FindTargets(findTargetFrequency)
	viewcastInfo.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
	
func _draw():
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

	for i in (rayNumber + 2):
		#print("i is: " + str(i))
		#print("Current angle: " + str(i * step))
		var angle = i * step
		var dir  = dirFromAngle((-viewAngle / 2) + angle, false)
		var dir_global = dirFromAngle((-viewAngle / 2) + angle, true)
		var physics = get_world_2d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters2D.create(global_position, global_position + dir * viewRadius, 0b110, [self])
		var result = physics.intersect_ray(rayQuery)
		if result.is_empty():
			draw_line(position, dir_global * viewRadius, Color.HONEYDEW)
		else:
			draw_line(position, dir_global * global_position.distance_to(result["position"]), Color.ORANGE)
		
		
# Takes in angle and spits out local relative vector, UP is 0
func dirFromAngle(angleInDegree: float, global: bool) -> Vector2:
	if not global:
		angleInDegree += global_rotation_degrees
		
	var radians: float = (angleInDegree) * PI/180
	return Vector2(cos(radians), sin(radians))
			draw_line(position, result["position"] - global_position, Color.ORANGE)


func newViewCastInfo(origin: Vector2, end: Vector2) -> Dictionary:
	var result:Dictionary = {}
	result = viewcastInfo_mold.duplicate()
	return result

#Subclass for RaycastInformation
class viewcastInfo :
	var origin: Vector2
	var end   : Vector2
	var position: Vector2
	
