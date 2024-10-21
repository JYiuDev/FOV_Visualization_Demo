extends CanvasLayer
class_name DebugUI

@export var FOVEntity: FOV

#FRONT RAY VARIABLES
var frontViewAngle: float:
	set(newAngle):
		frontViewAngle = newAngle
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	get_all_values()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_all_values() -> void:
	
	pass
