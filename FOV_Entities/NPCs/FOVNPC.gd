extends CharacterBody2D
class_name FOV_NPC

#FUNCTION: TEST SCRIPT OF TURNING THE SPRITE ON OR OFF DEPENDING ON THE DISTANCE AND ANGLE FROM AN FOV PLAYER
var player: CharacterBody2D

func _ready():
	player = Manager.player
	
func _process(delta):
	pass
	

func is_in_vision():
	if player:
		var player_dir:Vector2 = player.getFacing()
		var self_pos: Vector2 = to_global(position)
