extends OmniLight3D
#Muzzle/explosion flashes

@export var perma = false #keep the light on,  can be 'flipped' and will extinguish itself.
@export var decay_rate = 3.5 #Higher = Faster - how fast the light kills itself. 


func _physics_process(delta):
	if light_energy > 0 and !perma:
		light_energy -= delta * decay_rate
		if light_energy < 0:
			light_energy = 0
			queue_free()
#	else:
#		queue_free()
