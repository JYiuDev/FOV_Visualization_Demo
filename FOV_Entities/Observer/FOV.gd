extends Node2D
class_name FOV
@export var viewRadius: float 
@export var viewAngle:  float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Takes in angle and spits out local relative vector, UP is 0
func dirFromAngle() -> Vector2:
	return Vector2.ZERO
