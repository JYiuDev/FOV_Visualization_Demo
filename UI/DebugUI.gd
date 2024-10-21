extends CanvasLayer
class_name DebugUI

@export var FOVEntity: FOV

#FRONT RAY VARIABLES
var frontViewAngle: float:
	set(newAngle):
		frontViewAngle = newAngle
		update_frontViewAngle(frontViewAngle)

var frontRayAmount: int:
	set(newValue):
		frontRayAmount = maxi(0, newValue)
		update_frontRayAmt(frontRayAmount)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	#default testing values
	FOVEntity.viewAngleChange.connect(update_frontViewAngle)

func update_frontViewAngle(value: float) -> void:
	$Control/MarginContainer/DebugHUD/FrontRayGrp/FrontConeAngle/Val.text = str(value)

func update_frontRayAmt(value: int) -> void:
	$Control/MarginContainer/DebugHUD/FrontRayGrp/Amount/Val.text = str(value)

func update_frontRayLen(value: float) -> void:
	$Control/MarginContainer/DebugHUD/FrontRayGrp/Length/Val.text = str(value)

func update_periRayAmt(value: float) -> void:
	$Control/MarginContainer/DebugHUD/PeripheralGrp/Amount/Val.text = str(value)
	
func update_periRayLen(value: float) -> void:
	$Control/MarginContainer/DebugHUD/PeripheralGrp/Length/Val.text = str(value)
