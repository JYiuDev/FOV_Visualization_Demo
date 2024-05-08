extends Node2D

@export var fow: FOV
func _ready():
	pass
	
func _draw():
	
	#draw circle depending on FOV viewRadius
	draw_arc(position, fow.viewRadius, 0, 2 * PI, 90, Color.WHITE)
	
	draw_line(position, fow.dirFromAngle(-fow.viewAngle/2, true) * fow.viewRadius, Color.WHITE)
	draw_line(position, fow.dirFromAngle(fow.viewAngle/2 , true) * fow.viewRadius, Color.WHITE)
	drawRayAarray()

func _process(_delta):
	queue_redraw()
	
	

func drawVisibleTargets():
	#loop through array
	for targets:Dictionary in fow.targetsInRange:
		print(targets["collider"])

func drawRayAarray():
	var rayNumber:int = roundi(fow.viewAngle * fow.raycastResolution)
	
	#Instantiate array of Vector2, the array size will be rayNumber + 2 (for the outer most lines)
	var rayArray: Array
	var step: float = fow.viewAngle / (rayNumber + 2)
	
	for i in (rayNumber + 2):
		#print("i is: " + str(i))
		#print("Current angle: " + str(i * step))
		var angle = i * step
		var dir = fow.dirFromAngle((-fow.viewAngle / 2) + angle, true)
		draw_line(position, dir * fow.viewRadius * 2, Color.GREEN)
