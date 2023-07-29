extends AnimationPlayer
#20230414T1630; creation; it's meant to fire a large city wide effect after a time.
#20230709T2056; This one is meant for the player so crap can happen down below without depending on the player; changed up, see other copied srcs for info


@export var effect_time: int =  90
#func _ready():
	
	
##	get_parent().get_node("Pod/PodBox/MainV1/Ani").play("DoorFlapsClose")
##	var ttemp = get_tree().create_timer(1.2)
##	await ttemp.timeout
#	play("Drop")
##	print("poop")
#	var tttemp = get_tree().create_timer(30)
#	await tttemp.timeout
	
	
