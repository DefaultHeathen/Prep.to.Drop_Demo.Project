extends Node3D
#for the plasmashot from the turret.
#	when the rounds hit something and explode, it's jarring to see the trail vanish.
#	This allows it to finish it's presentation

@export var burnout_time = 5.0 #how many seconds until it frees itself. Set with Caller

func eject_defunct():
	#This doesn't get run as the caller calls queue_free() before/while this is done
	#However, this is a decent block for most effects to sure they stay in place
	#The order is important as well. 
	#	Setting the position while/before setting the parent, will error and set it at (0, 0, 0) on add_child()
	var new_home = get_parent().get_parent()
	var pos = global_transform
	get_parent().remove_child(self)
	new_home.add_child(self)
	global_transform = pos
#	var timer = get_tree().create_timer(burnout_time) #this also works btw, but you still need the await line.
	await get_tree().create_timer(burnout_time).timeout
	queue_free()

func ejected(): #Set up the nodes to allow the particles to finish
	$Glow.decay_rate = 6.5 #setting light to decay very fast
	$Glow.perma = false #turning off the light, the src lets it clear itself
	$TEffect.emitting = false #turning off particles, needed to prevent (these) particles from stacking = lag on quest
	await get_tree().create_timer(burnout_time).timeout
	queue_free()
