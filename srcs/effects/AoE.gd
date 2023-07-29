extends Area3D


@export var damage = 15
@export var dist_threshold: bool = true #psuedo shrapnel effect, reduced distance save

func _on_body_entered(body):
	if body.is_in_group("player_body"):
		var dist_var = body.global_position.distance_to(global_position)
		match dist_threshold:
		#possible ways to get a dynamic damage on an explosion 
#			false: 						#comment the other options, just have this one.
#				damage += dist_var 		#this seems braindead but it'll allow the effect. 
			
			true: 						#The most straight forward and won't be weird to adapt
				damage -= (dist_var*2) - damage #extreme damage falloff
		Omni.damage_effect(damage)
		
