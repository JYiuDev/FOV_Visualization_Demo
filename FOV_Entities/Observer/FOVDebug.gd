extends Node2D

@export var fow: FOV

func _draw():
	
	#draw circle depending on FOV viewRadius
	draw_arc(position, fow.viewRadius, 0, 2 * PI, 90, Color.WHITE)
	
	draw_line(position, fow.dirFromAngle(-fow.viewAngle/2, true) * fow.viewRadius, Color.WHITE)
	draw_line(position, fow.dirFromAngle(fow.viewAngle/2 , true) * fow.viewRadius, Color.WHITE)

func _process(_delta):
	queue_redraw()
	
	

func drawVisibleTargets():
	#loop through array
	for targets:Dictionary in fow.targetsInRange:
		print(targets["collider"])
