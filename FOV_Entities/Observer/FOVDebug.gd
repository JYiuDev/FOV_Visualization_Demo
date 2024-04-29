@tool
extends Node2D

@export var fow: FOV

func _draw():
	
	#draw circle depending on FOV viewRadius
	draw_arc(position, fow.viewRadius, 0, 2 * PI, 90, Color.ALICE_BLUE)
	
	var angle_test: Vector2 = Vector2(cos(90*PI), sin(90*PI)).normalized()
	draw_line(position, position + angle_test * fow.viewRadius, Color.RED)

func _process(_delta):
	queue_redraw()
