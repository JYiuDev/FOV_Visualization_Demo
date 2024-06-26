extends FOV
class_name  FOVDebug

@export var fow: FOV
var viewcastArray: Array = []

func _ready():
	pass
	
func _draw():
	
	#draw circle depending on FOV viewRadius
	draw_arc(position, fow.viewRadius, 0, 2 * PI, 90, Color.BLACK)
	
	draw_line(position, fow.dirFromAngle(-fow.viewAngle/2, true) * fow.viewRadius, Color.BLACK)
	draw_line(position, fow.dirFromAngle(fow.viewAngle/2 , true) * fow.viewRadius, Color.BLACK)
	
	if !viewcastArray.is_empty() :
		for i in viewcastArray.size():
			var viewcast = viewcastArray[i] as ViewcastInfo
			if viewcast.hit:
				draw_line(position, viewcast.point, Color.DEEP_PINK)
			else:
				draw_line(position, viewcast.point, Color.BLACK)
				

func _process(_delta):
	queue_redraw()

func drawVisibleTargets():
	#loop through array
	for targets:Dictionary in fow.targetsInRange:
		print(targets["collider"])

func drawRayAarray():
	var rayNumber:int = roundi(fow.viewAngle * fow.raycastResolution)
	
	#Instantiate array of Vector2, the array size will be rayNumber + 2 (for the outer most lines)
	var step: float = fow.viewAngle / (rayNumber + 1)
	
	for i in (rayNumber + 2):
		#print("i is: " + str(i))
		#print("Current angle: " + str(i * step))
		var angle = i * step
		var dir = fow.dirFromAngle((-fow.viewAngle / 2) + angle, true)
		draw_line(position, dir * fow.viewRadius, Color.HONEYDEW)
