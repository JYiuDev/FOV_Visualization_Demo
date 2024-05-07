extends Node2D
class_name FOV

@export var viewRadius: float 
@export var viewAngle:  float

@export_range(0.01, 1) var findTargetFrequency: float = 0.5
var targetsInRange: 	Array = []
var targetsInVision:	Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	FindTargets(findTargetFrequency)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()
	
func _draw():
	if targetsInVision.size() > 0:
		for target in targetsInVision:
			var degreeToTarget = get_angle_to(target.global_position)
			var dirToTarget    = Vector2(cos(degreeToTarget), sin(degreeToTarget))
			var disToTarget    = global_position.distance_to(target.global_position)
			draw_line(position, dirToTarget * disToTarget, Color.RED)

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
		var target: CharacterBody2D = targets["collider"]
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
	
	
# Takes in angle and spits out local relative vector, UP is 0
func dirFromAngle(angleInDegree: float, global: bool) -> Vector2:
	if not global:
		angleInDegree += rad_to_deg(transform.get_rotation()) 
		
	var radians: float = (angleInDegree - 90) * PI/180
	return Vector2(cos(radians), sin(radians))
