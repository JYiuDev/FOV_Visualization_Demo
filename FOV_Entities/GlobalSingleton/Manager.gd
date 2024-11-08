extends Node

var player: CharacterBody2D
var fov_texture: ViewportTexture

func add_player(new_player:CharacterBody2D):
	player = new_player

func add_fov_texture(new_texture: SubViewport):
	fov_texture = new_texture.get_texture()
