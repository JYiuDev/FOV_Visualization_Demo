extends CharacterBody2D

@export_range(0,500) var moveSpeed: float
var fov: FOV

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	faceMouse()
	
	
func _physics_process(_delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * moveSpeed
	move_and_slide()


func faceMouse():
	var angle = rotation + get_angle_to(get_global_mouse_position())
	rotation = angle

