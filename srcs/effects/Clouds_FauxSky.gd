@tool
extends Sprite3D

@export var rotate_speed = 0.01

func _physics_process(delta):
	rotation_degrees.z += rotate_speed * delta 
