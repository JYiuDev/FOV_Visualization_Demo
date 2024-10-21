extends Node2D

var lerp_num: int
var max_num: int = 10
var min_num: int = 0
var isLerping: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	lerp_num = 0
	var tween = create_tween()
	
	tween.tween_property(self, "lerp_num", max_num, 10)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(lerp_num)
