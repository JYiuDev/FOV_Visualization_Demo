@tool
extends CharacterBody2D

@export_range(0,500) var moveSpeed: float 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	faceMouse()
	move_and_slide()


func faceMouse():
	var angle = rotation + get_angle_to(get_global_mouse_position()) + deg_to_rad(90)
	rotation = angle
