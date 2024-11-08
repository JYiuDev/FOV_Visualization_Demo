extends CharacterBody2D
class_name FOV_NPC

#FUNCTION: TEST SCRIPT OF TURNING THE SPRITE ON OR OFF DEPENDING ON THE DISTANCE AND ANGLE FROM AN FOV PLAYER
var player: FOV_Character
var sprite: Sprite2D

func _ready():
	player = Manager.player
	sprite = $Sprite2D
	if(Manager.fov_texture):
		sprite.material.set_shader_parameter("mask_texture",Manager.fov_texture)
	else :
		print("NO FOV TEXTURE")

func _is_in_vision() -> bool:
	if player:
		var player_dir:Vector2 = player.getFacing().normalized()
		var player_to_self_dir: Vector2 = (global_position - player.global_position).normalized()
		var p: float = player_dir.dot(player_to_self_dir)
		var angle:float = rad_to_deg(acos(p))
		if angle < (player.fow.viewAngle * 0.5):
			print(self.to_string() + str(angle))
			return true
	return false
		
func _is_in_range() -> bool:
	if player:
		var fow:FOV = player.fow
		var viewRange: float = fow.viewRadius
		var dis: float = global_position.distance_to(player.global_position)
		if dis < viewRange:
			return true
	return false
