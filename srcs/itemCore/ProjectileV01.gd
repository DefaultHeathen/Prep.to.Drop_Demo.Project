extends Node3D
#for the plasma turret, this is the actual plasma shot itself.

var deleting = false

@export var speed = 10.0# Adjust this to control the speed of the node
@export var gravity = 1.0  # Adjust this to control the gravity effect
#var pos = Vector3(0, 0, 0)  # Initial position of the node
#var velocity = Vector3(0, 0, 0)  # Initial velocity of the node
@onready var hitray = $MeshInstance3D/HitCast #ray to properly place effects



#Consider creating a OmniTargetingSystem

func _ready():
	#let the 'spawning' func cook
	set_process(false)

func _physics_process(delta):
#		transform.origin.y -= gravity * delta  #gives fake "curve" effect. needs tweaking (needs a lot actually)
		transform.origin.z += speed * delta  # Move the node along the z-axis
#		rotation_degrees.x += 2 * delta #(this is part of the "a lot")
		set_position(position)


func _on_area_3d_body_entered(body):
	print("projectileV01.gd: area3D entered(): ",hitray.get_collision_point(), hitray.get_collider(), hitray.is_colliding())
	match deleting:
		false:
			deleting = true #prevents multiple calls
			OmniEffects.create_poof(4, self, false, null)
			
		#	$Trail.eject() #not fast enough
			var tail = $Trail
			var new_home = get_parent().get_parent()
			var pos = tail.global_transform
			remove_child(tail)
			new_home.add_child(tail)
			tail.global_transform = pos
			tail.ejected()
		#	await get_tree().create_timer(.1).timeout

			print("deleting!!")
			get_parent().queue_free()
